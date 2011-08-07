from statistics import DEFAULT_PORT, connect_statistics

import commands

def sitelogin(connection, name, password):
    value = connection.site_login(name, password)
    connection.send_chat(value) # so it doesn't appear in the log
    return False
        
commands.add(sitelogin)

def apply_script(protocol, connection, config):
    stats_config = config.get('statistics', {})
    host = stats_config.get('host', 'localhost')
    port = stats_config.get('port', DEFAULT_PORT)
    server_name = stats_config.get('server_name', 'stats server')
    password = stats_config.get('password', '')

    class StatisticsConnection(connection):
        login_defer = None
        stats_name = None
        
        def on_kill(self, killer):
            if killer not in (self, None):
                if killer.stats_name is not None:
                    self.protocol.stats.add_kill(killer.stats_name)
                if self.stats_name is not None:
                    self.protocol.stats.add_death(self.stats_name)
            return connection.on_kill(self, killer)
        
        def site_login(self, name, password):
            if self.stats_name is not None:
                return 'Already logged in.'
            if self.login_defer is not None:
                return 'Already requesting login.'
            self.login_defer = self.protocol.stats.login_user(name, password
                ).addCallback(self.on_site_login, name)
            return 'Attempting to login...'
        
        def on_site_login(self, result, name):
            if result:
                self.stats_name = name
                self.send_chat('Logged in as %s.' % name)
            else:
                self.send_chat('Invalid user/pass combination.')
            self.login_defer = None

    class StatisticsProtocol(protocol):
        stats = None
        def __init__(self, *arg, **kw):
            protocol.__init__(self, *arg, **kw)
            connect_statistics(host, port, server_name, password).addCallback(
                self.statistics_connected)
        
        def statistics_connected(self, stats):
            print 'Statistics server authenticated.'
            self.stats = stats
    
    return StatisticsProtocol, StatisticsConnection