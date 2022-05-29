<div align="center">
<h1>Wocky III</h1>
<p>The new all-in-one botnet with a special functional interpreter language to control and design your CNC plus zmap/shodan scanners and loaders!</p>
</div>

# What is Wocky?
Wocky is an advanced botnet build created for users to design their own CNC on the botnet, Built-in/External Scanners, and Built-in/External Loaders!

# Progress Status
❌ Haven't started | [🚧] In Development | ✔️ Finished
<table>
    <tr>
        <td width=35% valign=top>

* [CNC Server](#wocky-cnc)
    * [CNC Listener](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/wocky/client_cnc.v) {✔️}
    * [Connection Handler](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/wocky/client_handler.v) {✔️}
    * [Command System](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/wocky/client_handler.v) {✔️}
    * [Crud](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/crud) {🚧}
    * [Auth](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/auth) {🚧}
    * [Loggers](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/logger) {🚧}
    * [Attack System](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/attack_system) {✔️}
       </td>
       <td width=50% valign=top>
* [BOT Server](#wocky-bot)
    * Bot Listener {❌}
    * Connection Handler {❌}
    * Killer {❌}
    * Scanners {❌}
        </td>
        <td width=50% valign=top>
* [WockyFX](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/wockyfx)
    * Doc moved to the original repo
        </td>
    </tr>
</table>

# Wocky CNC
With Wocky, we provide an interpreter language called WockyFX so you can design and control your own commands. Unlike any other CNC/Botnet out you can create commands to geo locate, port scan, send attack or display a menu on the terminal by creating a wfx file! More info about WockyFX [Here](https://github.com/Eruptsy/WockyFX)
