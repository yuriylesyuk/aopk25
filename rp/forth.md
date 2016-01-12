```
```Screen # 0
  0 ( introduction                                       03/25/91 )
  1 ( +- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -+
  2   |                                                         |
  3   |    реализация игрушки Soko-ban предследует учебные      |
  4   |       цели и акцентирует внимание на критичных          |
  5   |         к процессу программирования местах              |
  6   |                                                         |
  7   |                                                         |
  8   |                                                         |
  9   |                      программа продолжает славную       |
 10   |                      серию реализаций игрушки Soko-ban  |
 11   |                      на различных языках программиро-   |
 12   |                      вания от Insight corp.,            |
 13   |                      представляя Forth                  |
 14   |                                                         |
 15   + -- -- -- -- -- -- -- -- -- -- (c) Insight corp., 1991 --+ )

Screen # 1
  0 ( слова для ввода клавиши и позиционирования курсора 01/04/80 )
  1 
  2 
  3 256  CONSTANT F_key ( системная константа -
  4                         смещение для скан-кодов )
  5 : GETKEY ( --- n )  ( системный ввод )
  6   KEY
  7   DUP 0= IF DROP KEY F_key + THEN
  8 ;
  9 
 10 : GOTO_XY ( x y --- )
 11   SWAP 2 * SWAP GOTOXY ;
 12 
 13 : BELL ( --- ) 7 EMIT ; ( выдача звукового сигнала на консоль )
 14 
 15 -->


Screen # 2
  0 ( определение констант                               01/04/80 )
  1 HEX
  2   ( коды клавиш управления )  1B   CONSTANT F_esc
  3                               20   CONSTANT F_restart
  4 F_key 4B + CONSTANT F_Left    F_key 4D + CONSTANT F_Right
  5 F_key 48 + CONSTANT F_Up      F_key 50 + CONSTANT F_Down
  6 
  7 80   CONSTANT C_ctrl_bit
  8 7F   CONSTANT C_bit_mask
  9            ( --- коды спрайтов игрушки --- )
 10 0  DUP CONSTANT S_fre_plc     C_ctrl_bit + CONSTANT Sb_fre_plc
 11 1  DUP CONSTANT S_man         C_ctrl_bit + CONSTANT Sb_man
 12 9  DUP CONSTANT S_wall        C_ctrl_bit + CONSTANT Sb_wall
 13 4  DUP CONSTANT S_box         C_ctrl_bit + CONSTANT Sb_box
 14 DECIMAL
 15 -->


Laboratory Microsystems PC/FORTH 2.0       21:24  10/11/90   rp.scr

Screen # 3
  0 ( игрушечные переменные                              03/23/91 )
  1 
  2   VARIABLE MAN_X   0 MAN_X !
  3   VARIABLE MAN_Y   0 MAN_Y !
  4 
  5   VARIABLE SCORE_ALL 0 SCORE_ALL ! ( максимальн.кол-во очков )
  6   VARIABLE SCORE_NEW 0 SCORE_NEW ! ( текущее кол-во очков    )
  7 
  8 : SCORE_ALL++ ( --- ) SCORE_ALL @ 1 + SCORE_ALL ! ;
  9 : SCORE_ALL-- ( --- ) SCORE_ALL @ 1 - SCORE_ALL ! ;
 10 : SCORE_NEW++ ( --- ) SCORE_NEW @ 1 + SCORE_NEW ! ;
 11 : SCORE_NEW-- ( --- ) SCORE_NEW @ 1 - SCORE_NEW ! ;
 12 
 13   VARIABLE KBRD_KEY  ( введенный с калвиатуры символ )
 14 
 15 -->


Screen # 4
  0 ( определение типа ARRAY и определение поля игры     03/22/91 )
  1 30 CONSTANT GF_col
  2 20 CONSTANT GF_row
  3 : ARRAY ( #col #row --- )
  4         SWAP CREATE OVER , * ALLOT
  5   DOES> ( #col #row --- A )
  6         DUP @ ROT * + + 2+ ;
  7 
  8 GF_row GF_col ARRAY GF
  9 
 10 : GF@ ( #col #row --- n ) GF C@ ;
 11 : GF! ( n #col #row --- ) GF C! ;
 12 : .GF ( \ cod-line ( #col #row --- )
 13   GF ASCII # WORD COUNT ROT SWAP CMOVE> ;
 14 
 15 -->


Screen # 5
  0 ( инициализация игровой ситуации                     03/22/91 )
  1 : GF_CLEAR ( -- ) GF_row 0 DO GF_col 0 DO 0 I J GF! LOOP LOOP ;
  2 GF_CLEAR
  3 0  1 .GF 00000009999900000000000000000000#
  4 0  2 .GF 00000009000900000000000000000000#
  5 0  3 .GF 00000009000900000000000000000000#
  6 0  4 .GF 00000009400900000000000000000000#
  7 0  5 .GF 00000999004999000000000000000000#
  8 0  6 .GF 00000900400409000000000000000000#
  9 0  7 .GF 00099909099909000009999990000000#
 10 0  8 .GF 00090009099909999999003390000000#
 11 0  9 .GF 00090400400000000000003390000000#
 12 0 10 .GF 00099999099990919999003390000000#
 13 0 11 .GF 00000009000000999009999990000000#
 14 0 12 .GF 00000009999999900000000000000000#
 15 -->


Laboratory Microsystems PC/FORTH 2.0       21:24  10/11/90   rp.scr

Screen # 6
  0 ( конвертер внешнего представления игры в внутреннее 03/23/91 )
  1 
  2 : GF_CONVERT ( --- )
  3   GF_row 0 DO GF_col 0 DO I J GF@ CASE
  4          ASCII 0 OF S_fre_plc  ENDOF
  5          ASCII 9 OF S_wall     ENDOF
  6          ASCII 4 OF S_box      ENDOF
  7          ASCII 3 OF Sb_fre_plc SCORE_ALL++ ENDOF
  8          ASCII 7 OF Sb_box SCORE_NEW++ SCORE_ALL++ ENDOF
  9          ASCII 1 OF S_man    I MAN_X ! J MAN_Y ! ENDOF
 10          ASCII # OF S_fre_plc  ENDOF
 11          ( default ) S_fre_plc SWAP
 12   ENDCASE I J GF! LOOP LOOP ;
 13 -->
 14 
 15 


Screen # 7
  0 ( вывод спрайта                                      03/23/91 )
  1 : SPRITE_OUT ( n --- )
  2   CASE
  3     S_fre_plc     OF ."   " ENDOF
  4     Sb_fre_plc    OF ." . " ENDOF
  5     S_wall        OF 178 EMIT 178 EMIT ENDOF
  6     Sb_wall       OF 178 EMIT 178 EMIT ENDOF
  7     S_man         OF ." ><" ENDOF
  8     Sb_man        OF ." ><" ENDOF
  9     S_box         OF ." <>" ENDOF
 10     Sb_box        OF 17  EMIT 16  EMIT ENDOF
 11   ENDCASE ;
 12 -->
 13 
 14 
 15 


Screen # 8
  0 ( системный вывод спрайта                            03/23/91 )
  1 : SPRITE_SHOW ( x y t --- )
  2   >R 2DUP GF@ Sb_box = IF
  3     R> DUP >R S_box <> IF SCORE_NEW-- THEN THEN
  4   2DUP GF@ C_ctrl_bit AND 0 <> IF
  5     R> DUP >R S_box  = IF SCORE_NEW++ THEN THEN
  6   2DUP GF DUP C@ C_ctrl_bit AND R> OR DUP >R SWAP C!
  7 
  8   GOTO_XY R> SPRITE_OUT ;
  9 
 10 : GF_SHOW ( --- )
 11   GF_row 0 DO GF_col 0 DO I J 2DUP GF@ SPRITE_SHOW LOOP LOOP ;
 12 
 13 -->
 14 
 15 


Laboratory Microsystems PC/FORTH 2.0       21:24  10/11/90   rp.scr

Screen # 9
  0 ( слово MOVING - изюминка нашего дела                03/23/91 )
  1 : MOVING ( dlt_x dlt_y --- ) 2DUP
  2   >R MAN_X @ + R> MAN_Y @ + GF@ C_bit_mask AND S_fre_plc =
  3   IF   >R MAN_X @ + MAN_X ! R> MAN_Y @ + MAN_Y !
  4   ELSE 2DUP
  5        >R MAN_X @ + R> MAN_Y @ + GF@ C_bit_mask AND S_box =
  6        IF 2DUP >R 2 * MAN_X @ + R> 2 * MAN_Y @ +
  7           GF@ C_bit_mask AND S_fre_plc =
  8           IF   2DUP >R MAN_X @ + R> MAN_Y @ + S_fre_plc
  9                SPRITE_SHOW
 10                2DUP >R 2 * MAN_X @ + R> 2 * MAN_Y @ + S_box
 11                SPRITE_SHOW
 12                >R MAN_X @ + MAN_X ! R> MAN_Y @ + MAN_Y !
 13           ELSE 2DROP THEN
 14        ELSE 2DROP THEN
 15   THEN ;   -->


Screen # 10
  0 ( основной цикл игры                                 03/23/91 )
  1 : GAME_ROUND ( --- )
  2   BEGIN
  3     MAN_X @ MAN_Y @ S_man     SPRITE_SHOW
  4     GETKEY KBRD_KEY !
  5     MAN_X @ MAN_Y @ S_fre_plc SPRITE_SHOW
  6     KBRD_KEY @ CASE
  7                F_Left  OF -1 0 MOVING ENDOF
  8                F_Right OF  1 0 MOVING ENDOF
  9                F_Up    OF 0 -1 MOVING ENDOF
 10                F_Down  OF 0  1 MOVING ENDOF
 11             ENDCASE
 12   SCORE_NEW @ SCORE_ALL @ =
 13      KBRD_KEY @ F_esc =
 14      KBRD_KEY @ F_restart = OR OR UNTIL ;
 15 -->


Screen # 11
  0 ( запуск игры и раздача слоников                     03/23/91 )
  1 : GAME_PUSHER ( --- )
  2 GF_CONVERT
  3 GF_SHOW       BELL BELL
  4 
  5 GAME_ROUND
  6 
  7 10 17 GOTO_XY BELL BELL BELL
  8 SCORE_NEW @ SCORE_ALL @ =
  9 IF    ." МАЛАДЕЦ "
 10 ELSE  ." СЛАББАК "
 11 THEN
 12 10 19 GOTO_XY ;
 13 
 14 GAME_PUSHER ( ...поехали! )
 15 

Laboratory Microsystems PC/FORTH 2.0       21:24  10/11/90   rp.scr
```