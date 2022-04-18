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
* [BOT Server](#wocky-bot)
    * Bot Listener {❌}
    * Connection Handler {❌}
    * Killer {❌}
    * Scanners {❌}
        </td>
        <td width=50% valign=top>
* [WockyFX](#wockyfx)
    * [Variables](https://github.com/Skrillec-Security/Wocky-III/blob/750b5878382f6eca0e3bbec41d4620fdddc9dedf/core/wockyfx/main.v#L30) {✔️}
    * [Functions](https://github.com/Skrillec-Security/Wocky-III/blob/750b5878382f6eca0e3bbec41d4620fdddc9dedf/core/wockyfx/main.v#L37) {🚧}
        * [Function argument Count Checker for errors] {❌}
        * [Parse function argument datatypes] {❌}
    * [For loop](https://github.com/Skrillec-Security/Wocky-III/blob/750b5878382f6eca0e3bbec41d4620fdddc9dedf/core/wockyfx/main.v#L56)
    * [Required Used 'perm' Key Or Exit](https://github.com/Skrillec-Security/Wocky-III/blob/750b5878382f6eca0e3bbec41d4620fdddc9dedf/core/wockyfx/main.v#L100) {✔️}
    * [Required to use set_arg_err_msg() when using set_max_arg()](https://github.com/Skrillec-Security/Wocky-III/blob/750b5878382f6eca0e3bbec41d4620fdddc9dedf/core/wockyfx/main.v#L114) {✔️}
        </td>
    </tr>
</table>

# Wocky CNC
With Wocky, we provide an interpreter language called WockyFX so you can design and control your own commands. Unlike any other CNC/Botnet out you can create commands to geo locate, port scan, send attack or display a menu on the terminal by creating a wfx file! More info about WockyFX [Here](https://github.com/Skrillec-Security/Wocky-III/tree/main/core/wockyfx)
# Wocky Bot

# WockyFX
