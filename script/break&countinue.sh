while
do
commands
commands

 break--------+
              |
commands      |
commands      | 跳出当前循环（通常在循环体中与条件语句一起使用）
              |
 done         |
              |
commands<-----+
commands


while<-------+
 do          |
             |
commands     | 跳回当前循环，重新开始下一次循环（通常在循环体中与条件语句一起使用）
commands     |
             |
 continue----+

commands
commands
commands
 done
commands
commands