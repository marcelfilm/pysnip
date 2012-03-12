# Copyright (c) James Hofmann 2012.

# This file is part of pyspades.

# pyspades is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# pyspades is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with pyspades.  If not, see <http://www.gnu.org/licenses/>.

from twisted.internet import reactor
from twisted.internet.task import LoopingCall

class VoteKick(object):
    
    vote_percentage = 0.
    vote_time = 0.
    vote_interval = 0.
    votekick_public_votes = True
    ban_duration = 0.
    votes = {}
    instigator = None
    target = None
    protocol = None
    reason = None
    kicked = False
    
    def __init__(self, connection, player, reason = None):
        if reason is None:
            reason = 'NO REASON GIVEN'
        self.instigator = connection
        self.target = player
        self.protocol = connection.protocol
        self.vote_percentage = self.protocol.votekick_percentage
        self.vote_time = self.protocol.votekick_time
        self.vote_interval = self.protocol.votekick_interval
        self.ban_duration = self.protocol.votekick_ban_duration
        self.votekick_public_votes = self.protocol.votekick_public_votes
        self.reason = reason
        self.kicked = False
    def votes_left(self):
        return int(((len(self.protocol.players) - 1) / 100.0
            ) * self.vote_percentage) - len(self.votes)
    def timeout(self):
        return "Votekick timed out"
    def verify(self):
        target = self.target
        instigator = self.instigator
        if self.votes_left() <= 0:
            return 'Not enough players on server.'
        elif target is instigator:
            return "You can't votekick yourself."
        elif target.admin:
            return 'Cannot votekick an administrator.'
        last_votekick = instigator.last_votekick
        if (last_votekick is not None and
        reactor.seconds() - last_votekick < self.vote_interval):
            return "You can't start a votekick now."
    def start(self):
        instigator = self.instigator
        target = self.target
        reason = self.reason
        protocol = self.protocol
        self.votes = {self.instigator : True}
        protocol.irc_say(
            '* %s initiated a votekick against player %s.%s' % (instigator.name,
            target.name, ' Reason: %s' % reason if reason else ''))
        protocol.send_chat(
            '%s initiated a VOTEKICK against player %s. Say /y to '
            'agree.' % (instigator.name, target.name), sender = instigator)
        protocol.send_chat('Reason: %s' % reason, sender = instigator)
        instigator.send_chat('You initiated a VOTEKICK against %s. '
            'Say /cancel to stop it at any time.' % target.name)
        instigator.send_chat('Reason: %s' % reason)
    def vote(self, connection):
        if connection is self.target:
            return "The votekick victim can't vote."
        if self.votes is None or connection in self.votes:
            return
        self.votes[connection] = True
        if self.votekick_public_votes:
            self.protocol.send_chat('%s voted YES.' % connection.name)
        if self.votes_left() <= 0:
            self.on_majority()
    def cancel(self, connection = None):
        if (connection and not connection.admin and 
            connection is not self.instigator):
            return 'You did not start the votekick.'
        if connection is None:
            message = 'Cancelled'
        else:
            message = 'Cancelled by %s' % connection.name
        self.show_result(message)
        self.protocol._finish_vote()
    def update(self):
        reason = self.reason if self.reason else 'none'
        self.protocol.send_chat(
            '%s is votekicking %s for reason: %s. Say /y to vote '
            '(%s needed)' % (self.instigator.name,
            self.target.name, reason, self.votes_left()))
    def on_disconnect(self, connection):
        if self.kicked:
            return
        if self.instigator is connection:
            self.cancel(self.instigator)
        elif self.target is connection:
            self.show_result("%s left during votekick" % self.target.name)
            if self.protocol.votekick_ban_duration:
                self.do_kick()
    def on_player_banned(self, connection):
        self.cancel(connection)
    def on_timeout(self):
        self.show_result("Votekick timed out")
        self.protocol._finish_vote()
    def on_majority(self):
        self.show_result("Player kicked")
        self.kicked = True
        self.do_kick()
        self.protocol._finish_vote()
    def show_result(self, result):
        self.protocol.send_chat(
            'Votekick for %s has ended. %s.' % (self.target.name,
                                                result), irc = True)
        if not self.instigator.admin: # set the cooldown
            self.instigator.last_votekick = reactor.seconds()        
    def do_kick(self):
        if self.protocol.votekick_ban_duration:
            self.target.ban(self.reason, self.ban_duration)
        else:
            self.target.kick(silent = True)

# Current status:

# I should do another round of factoring AFTER this one,
# so that "vote" and "votekick" are better differentiated.
