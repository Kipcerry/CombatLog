This script adds a Rust-inspired combat log system that temporarily tracks recent combat interactions between players.

Whenever a player deals or receives damage, the event is stored in a personal combat log. Players can view their recent incoming and outgoing hits using a command, including detailed combat information. To prevent spam, the combat log can only be opened again after a configurable delay.

An admin or player command is included to wipe the combat log, keeping the system clean and temporary.

Features

Rust-inspired temporary combat log system

Tracks incoming and outgoing damage events

Configurable cooldown before reopening the combat log

Optional detailed logging:

Attacker and victim

Weapon or damage type

Hit bone

Damage dealt

Old and new health values

Distance between players

Command to view the combat log

Command to wipe the combat log

Fully configurable via the Config file

This script is lightweight, non-intrusive, and designed to provide clear combat feedback without affecting gameplay balance.
