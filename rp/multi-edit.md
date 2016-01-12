```
$MACRO RP TRANS;
{*******************************MULTI-EDIT MACRO******************************

Name:  RP    ( russian pusher - altrnative name of Soko-Ban )

Description: программа продолжает славную серию реализаций игрушки
             Soko-Ban на различных языках программирования
             от Insight corp.,
             представляя Multi-Edit...

               (C) Copyright 1991 by Insight corp.
******************************************************************************}

  { Несколько слов о соглашениях именования переменных в языке, 
  облегчающих программирования.

  Поскольку регистр в именах переменных - неважен, имена принято нагружать 
  дополнительным смыслом. а именно:
    если все буквы в имени переменной - большие, то данная переменная 
    используется как константа;
    собственно переменные в MultiEdit обозначаются одним или несколькими
    словами, написанными через символ подчеркивание, все слова начинаются 
    с большой буквы;
    если в переменной до символа подчеркивания две больших буквы, а дальше
    - маленькие, то данная переменная будет формальным параметром в 
    функции                                                            }

  Def_Int( F_KEY, F_ESC, F_RESTART, F_LEFT, F_RIGHT, F_UP, F_DOWN,
       C_CTRL_BIT, C_BIT_MASK,
       S_FREE_PLACE, SB_FREE_PLACE, S_MAN, SB_MAN, S_WALL, SB_WALL,
       S_BOX, SB_BOX );

  F_KEY   := 256;

  F_ESC   := 27;              F_RESTART := 32;
  F_LEFT  := F_KEY + $4b;
  F_RIGHT := F_KEY + $4d;
  F_UP    := F_KEY + $48;
  F_DOWN  := F_KEY + $50;

  C_CTRL_BIT := $80;
  C_BIT_MASK := $7f;


  S_FREE_PLACE := 0;        SB_FREE_PLACE := C_CTRL_BIT + S_FREE_PLACE;
  S_MAN        := 1;        SB_MAN        := C_CTRL_BIT + S_MAN;
  S_WALL       := 9;        SB_WALL       := C_CTRL_BIT + S_WALL;
  S_BOX        := 4;        SB_BOX        := C_CTRL_BIT + S_BOX;


  Def_Int( i, j,
           Man_X, Man_Y,
           Kbrd_Key,
           Score_New, Score_All
           ) ;
  Def_Int( SS_x, SS_y, SS_d, SS_type,
           MV_x, MV_y
           );

  { задаем длину массива: 20 * 31 = 620 }
  Def_Str( Maze[ 620 ], GF[ 620 ],
         SS_char[ 2 ] );


  Put_Box( 5, 4, 70, 20, RED, WHITE,
           ь Soko-Ban game /Multi-Edit version/ ь, TRUE );
  Beep;

{-----------------------------------------------------------------------------}

 { исходное поле игры }
 {                      0        1         2         3   }
 {                      1234567890123456789012345678901  }
        Maze :=        ь000000000000000000000000000000ь;
        Maze := Maze + ь000000099999000000000000000000ь;
        Maze := Maze + ь000000090009000000000000000000ь;
        Maze := Maze + ь000000094009000000000000000000ь;
        Maze := Maze + ь000009990049990000000000000000ь;
        Maze := Maze + ь000009004004090000000000000000ь;
        Maze := Maze + ь000999090999090000099999900000ь;
        Maze := Maze + ь000900090999099999990033900000ь;
        Maze := Maze + ь000904004000000000000033900000ь;
        Maze := Maze + ь000999990999909199990033900000ь;
        Maze := Maze + ь000000090000009990099999900000ь;
        Maze := Maze + ь000000099999999000000000000000ь;
        Maze := Maze + ь000000000000000000000000000000ь;

 {----------------------- считывание лабиринта -----------------------}
  Score_All := 0;
  Score_New := 0;

  Def_Char( Crnt );
  i := 0;
  while ( i <= 12 ) do
    j := 1;
    while ( j <= 30 ) do
      SS_x := j;
      SS_y := i;
      Crnt := Copy( Maze, j+(i*30), 1 );
           if      ( Crnt = ь0ь ) then
                   SS_d := S_FREE_PLACE;
           else if ( Crnt = ь9ь ) then
                   SS_d := S_WALL;
           else if ( Crnt = ь4ь ) then
                   SS_d := S_BOX;
           else if ( Crnt = ь3ь ) then
                   SS_d := Sb_free_place;
                   Score_All := Score_All + 1;
           else if ( Crnt = ь7ь ) then
                   SS_d := SB_BOX;
                   Score_All := Score_All + 1;
                   Score_New := Score_New + 1;
           else if ( Crnt = ь1ь ) then
                   SS_d := S_MAN;
                   Man_X := j;
                   Man_Y := i;
           else if ( Crnt = ь2ь ) then
                   SS_d := Sb_MAN;
                   Man_X := j;
                   Man_Y := i;
                   Score_All := Score_All + 1;
           end; end; end; end; end; end; end;
      call Sprite_Show;
      j := j+1;
    end;
    i := i+1;
  end;
{---------------------------------------------------------------------}

  Write( ь Left/Right/Down/Up - moving  Esc/Space - exit ь,
            14, 19, RED, WHITE );
  Beep; Beep;
  { основной цикл игрушки }

  Def_Int( Game_Yes );

  Game_Yes := TRUE;
  while ( Game_Yes ) do
    SS_x := Man_X; SS_Y := Man_Y; SS_d := S_MAN;
    call Sprite_show;

    Read_Key;   { введем символ }
    if ( Key1 = 0 ) then
         Kbrd_Key := F_KEY + key2;
    else Kbrd_Key := Key1;    end;

    SS_x := Man_X; SS_y := Man_Y; SS_d := S_FREE_PLACE;
    call Sprite_Show;

        if      ( Kbrd_Key = F_LEFT ) then
                MV_x := -1; MV_y := 0;
                call Moving;
        else if ( Kbrd_Key = F_RIGHT ) then
                MV_x := 1; MV_y :=  0;
                call Moving;
        else if ( Kbrd_Key = F_UP ) then
                MV_x := 0; MV_y := -1;
                call Moving;
        else if ( Kbrd_Key = F_DOWN ) then
                MV_x :=  0; MV_y := 1;
                call Moving;
        end; end; end; end;

    if ( ( Score_New = Score_All )
       or ( Kbrd_Key = F_ESC ) or ( Kbrd_Key = F_RESTART ) ) then
       Game_Yes := FALSE;
    end;
  end;
{-----------------------------------------------------------------------------}


  if ( Score_New = Score_All ) then
      Write( ьммммммммммммм ***   maладец!  *** мммммммммммммь,
             14, 19, RED, WHITE );
  else
      Write( ьммммммммммммм *** слаб-б-бак! *** мммммммммммммь,
             14, 19, RED, WHITE );
  end;

  Beep; Beep; Beep;
  Read_Key;

  Kill_Box;


goto End_Of_Macro;
{-----------------------------------------------------------------------------}


{************************MULTI-EDIT MACRO SUBROUTINE**************************

Subroutine Name:

Subroutine Description:


******************************************************************************}

Sprite_Show: { подпрограмма вывода спрайта /локальная/
                 SS_x - координата по горизонтали
                 SS_y - координата по вертикали
                 SS_d - данное }
      if ( Ascii(Copy( GF, SS_y*30+SS_x, 1) ) = SB_BOX ) then
         if ( SS_d <> S_BOX ) then
            Score_New := Score_New - 1;
      end; end;
      if ( (Ascii(Copy( GF, SS_y*30+SS_x, 1) )
         and  C_CTRL_BIT ) <> 0  )  then
         if (SS_d = S_BOX ) then
            Score_New := Score_New + 1;
      end; end;

      GF := Str_Ins( Char( (Ascii(Copy( GF, SS_y*30+SS_x, 1 ))
                              and C_CTRL_BIT ) or (SS_d) ),
                     Str_del( GF, SS_y*30+SS_x, 1),
                     SS_y*30+SS_x
                   );

      { выводим спрайт на экран /бывшая sprite_out/ }
      SS_type := Ascii( Copy( GF, SS_y*30+SS_x, 1 ) );
      if      ( SS_type = S_FREE_PLACE ) then
              SS_char := ь  ь;
      else if ( SS_type = SB_FREE_PLACE ) then
              SS_char := ь. ь;
      else if (( SS_type = S_MAN ) or (SS_type = SB_MAN )) then
              SS_char := ь><ь;
      else if (( SS_type = S_WALL ) or (SS_type = SB_WALL )) then
              SS_char := Char( 178 ) + Char( 178 );
      else if ( SS_type = S_BOX ) then
              SS_char := ь<>ь;
      else if ( SS_type = SB_BOX ) then
              SS_char := Char( 17 ) + Char( 16 );
      end; end; end; end; end; end;

      Write( SS_char, 5 +(SS_x*2), 5+SS_y, RED, WHITE );

      ret;

{************************MULTI-EDIT MACRO SUBROUTINE**************************

Subroutine Name:

Subroutine Descroption:



******************************************************************************}

Moving: { процедура верификации перемещения двигателя
             /MV_x смещение координаты по горизонтали
             /MV_y смещение координаты по вертикали
          }
      { свободно ли следующее поле }
      if ( Ascii( Copy( GF, (Man_Y+MV_y)*30+(Man_X+MV_x), 1))
         and C_BIT_MASK = S_FREE_PLACE  ) then

         Man_X := Man_X + MV_x;
         Man_Y := Man_Y + MV_y;
      else { проверим, может это ящик }
         if ( Ascii( Copy( GF, (Man_Y+MV_y)*30+(man_x+MV_x), 1))
            and C_BIT_MASK = S_BOX   ) then

            if ( Ascii( Copy( GF, (Man_Y+(MV_y*2))*30+(Man_X+(MV_x*2)), 1))
               and C_BIT_MASK = S_FREE_PLACE ) then

               { переместить двигатель и ящик в данном направлении }
               SS_x := Man_X + MV_x;
               SS_y := Man_Y + MV_y;
               SS_d := S_FREE_PLACE;
               call Sprite_Show;
               SS_x := Man_X + (MV_x*2);
               SS_y := Man_Y + (MV_y*2);
               SS_d := S_BOX;
               call Sprite_Show;
               Man_X := Man_X + MV_x;
               Man_Y := Man_Y + mv_y;
            end;
         end;
      end;
      ret;
{-----------------------------------------------------------------------------}

End_Of_Macro:
END_MACRO;
```