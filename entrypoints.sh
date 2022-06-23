#!/bin/bash
# Update Game
./steamcmd.sh +login anonymous +force_install_dir ./l4d2 +app_update 222860 +quit

# Server Config
cat > l4d2/left4dead2/cfg/server.cfg <<EOF
hostname "${HOSTNAME}"
sv_region ${REGION}
#rcon_password "$RCONPASSWD" // Rcon password, used for remote access mostly.
#sv_steamgroup 42565145
sv_logecho 1
#mp_disable_autokick 1 // Deshabilita el kick automático de jugadores
// [GAME MODE]
sv_gametypes "coop, versus, mutation"
sm_cvar mp_gamemode "$MODE"

// Bans
// execute banned.cfgs at server start. Optimally at launch commandline.
exec banned_user.cfg  //loads banned users' ids
exec banned_ip.cfg      //loads banned users' ips
writeip          // Save the ban list to banned_ip.cfg.
writeid          // Wrties a list of permanently-banned user IDs to banned_user.cfg.
#sv_steamgroup_exclusive "1"              // If set, only members of Steam group will be able to join the server when it's empty, public people will be able to join the server only if it has players.
#                                         // (Forcing the IP as a non-group member in lobby, or directly connecting always works)
#// [Other Neat Stuff]
#// -----------------------------------------------------------------------
#sv_allow_lobby_connect_only "0"          // If set to 1, players may only join this server from matchmaking lobby, may not connect directly.

#// [File Consistency]
#// -----------------------------------------------------------------------
#sv_consistency "1"                       // Whether the server enforces file consistency for critical files.
#sv_pure "2"                              // The server will force all client files to come from Steam and additional files matching the Server.
#sv_pure_kick_clients "1"                 // If set to 1, the server will kick clients with mismatching files.

#// [Logging]
#// -----------------------------------------------------------------------
#log on                                   //Creates a logfile (on | off)
#sv_logecho 0                             //default 0; Echo log information to the console.
#sv_logfile 1                             //default 1; Log server information in the log file.
#sv_log_onefile 0                         //default 0; Log server information to only one file.
#sv_logbans 1                             //default 0;Log server bans in the server logs.
#sv_logflush 0                            //default 0; Flush the log files to disk on each write (slow).
#sv_logsdir logs                          //Folder in the game directory where server logs will be stored.

#// [Wait Commands]
#sm_cvar sv_allow_wait_command 0

#// [Networking, Rates]
#// - Rates forced to 100 on Clients, for 100 Tick.
#// - When using a different Tickrate, modify settings accordingly:
#// 1. Change 100000 to (Tickrate * 1000) for Rate and Splitpacket.
#$// 2. Change 100 to (Tickrate) for Cmd and Update Rates.
#$// -----------------------------------------------------------------------
#sm_cvar sv_minrate 100000                     // Minimum value of rate.
#sm_cvar sv_maxrate 100000                     // Maximum Value of rate.
#sm_cvar sv_minupdaterate 100                  // Minimum Value of cl_updaterate.
#sm_cvar sv_maxupdaterate 100                  // Maximum Value of cl_updaterate.
#sm_cvar sv_mincmdrate 100                     // Minimum value of cl_cmdrate.
#sm_cvar sv_maxcmdrate 100                     // Maximum value of cl_cmdrate.
#sm_cvar sv_client_min_interp_ratio -1         // Minimum value of cl_interp_ratio.
#sm_cvar sv_client_max_interp_ratio 0          // Maximum value of cl_interp_ratio.
#sm_cvar nb_update_frequency 0.014             // The lower the value, the more often common infected and witches get updated (Pathing, and state), very CPU Intensive. (0.100 is default)
#sm_cvar net_splitpacket_maxrate 50000         // Networking Tweaks.
#sm_cvar fps_max 0                             // Forces the maximum amount of FPS the CPU has available for the Server.

#// Tickrate Fixes
#sm_cvar tick_door_speed 1.3

// Slots (This prevents constant resetting of sv_maxplayers on map change. need moreplayers.zip)
#sm_cvar mv_maxplayers $PLAYERS
#sm_cvar sv_visiblemaxplayers $PLAYERS
#sm_cvar sv_removehumanlimit 1
#sm_cvar sv_force_unreserved 1

## // Prevents some shuffling.
#sm_cvar sv_unlag_fixstuck 1                   // Prevent getting stuck when attempting to "unlag" a player.
#sm_cvar z_brawl_chance 0                      // Common Infected won't randomly fight eachother.
#sm_cvar sv_maxunlag 1                         // Maximum amount of seconds to "unlag", go back in time.
#sm_cvar sv_forcepreload 1                     // Pre-loading is always a good thing, force pre-loading on all clients.
#sm_cvar sv_client_predict 1                   // This is already set on clients, but force them to predict.
#sm_cvar sv_client_cmdrate_difference 0        // Remove the clamp.
#sm_cvar sv_max_queries_sec_global 10
#3sm_cvar sv_max_queries_sec 3
#sm_cvar sv_max_queries_window 10
#sm_cvar sv_player_stuck_tolerance 5
#sm_cvar sv_stats 0                            // Don't need these.
#sm_cvar sv_clockcorrection_msecs 25           // This one makes laggy players have less of an advantage regarding hitbox (as the server normally compensates for 60msec, lowering it below 15 will make some players appear stuttery)

EOF

# Server Config admin
cat > l4d2/left4dead2/addons/sourcemod/configs/admins.cfg <<EOF

Admins
{
"$STEAMNAME"
        {
                "auth"                  "steam"
                "identity"              "$STEAMID"
                "flags"                 "z"
        }
}

EOF


cat > l4d2/left4dead2/addons/sourcemod/configs/admins_simple.ini <<EOF

 "$STEAM_ID"            "z"

EOF


cat > l4d2/left4dead2/host.txt <<EOF
http://sirpleaseny.site.nfoservers.com/compreworkhost.html
EOF

cat > l4d2/left4dead2/motd.txt <<EOF
http://sirpleaseny.site.nfoservers.com/comprework.html
EOF

# Start Game
cd l4d2 && ./srcds_run -console -game left4dead2 -port "$PORT" +maxplayers "$PLAYERS" +map "$MAP"