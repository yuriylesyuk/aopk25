```
/////////////////////////  rp.slt - russian pusher //////////////////////////

//
//   - Written.....: by Insight corp.
//   - Date........:    09/04/91 02:24am
//   - Subject.....: программа продолжает славную серию реализаций игрушки 
//       Soko-Ban на различных языках программирования, 
//       представляя язык SALT телекоммуникационного пакета Telix...
//   - Compile line: cs rp

//   ------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////////

int f_esc       = 0x001b,
    f_restart   = 0x0020;

int f_left      = 0x4b00,
    f_right     = 0x4d00,
    f_up        = 0x4800,
    f_down      = 0x5000;

//                15 + (16 * 04)  -- белым по красному
int game_color  = 0x4f;

int c_cntrl_bit = 0x80,
    c_bit_mask  = 0x7f;

int s_free_place,  s_man,  s_wall,  s_box,
    sb_free_place, sb_man, sb_wall, sb_box;


//  30 * 13 = 390
str maze[ 390 ];    // фактически - локальная переменная, но ограничение
                    // длины локальных переменных до 255 символов
                    // вынуждает вынести ее на глобальное место

str game_field[ 390 ]; // массив содержит рабочий массив игрушки


int man_x, man_y,   // координаты двигателя

   score_all, score_new, // переменные содержат счетчики очков

   kbrd_key;        // введенный символ

//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\
main()
{
 int work_frame;

    // фактически - инициализация констант, но невозможность
    // использовать при инициализации выражения вынуждает
    // инициировать эти константы здесь
    s_free_place = 0;      sb_free_place = c_cntrl_bit + s_free_place;
    s_man = 1;             sb_man = c_cntrl_bit + s_man;
    s_wall = 9;            sb_wall = c_cntrl_bit + s_wall;
    s_box = 4;             sb_box = c_cntrl_bit + s_box;

 cursor_onoff ( 0 );
 work_frame = vsavearea ( 5, 4, 70, 20 );
 box ( 5, 4, 70, 20, 2, 0, game_color );

 alarm ( 1 );


 pstraxy ( "(c) Insight corp., 1991", 25, 16, game_color );
 pstraxy ( "Init iNit inIt iniT....", 25, 18, game_color );
 maze_init ();

 pstraxy ( "Moving Up/Down/Left/Right : Finish Esc/Space",
           18, 18, game_color );
 alarm ( 1 );
 game_round ();

 pstraxy ( "                                            " ,
           18, 18, game_color );
 gotoxy ( 28, 18 );
 if ( score_new == score_all )
   pstra ( "*** маладец! ***", game_color );
 else
   pstra ( "*** слаб-ба-к ***", game_color );
 alarm ( 1 );

 kbrd_key = inkeyw ();
 vrstrarea ( work_frame );
 cursor_onoff ( 1 );
}
//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\//\



//------------------//----------------------//-------------------//--------//

// -------- функции сконструированные для работы с массивами -----------
// выбрать элемент из массива array по координате [colunm, row]
item_from_array ( str array, int column, int row )
{
 return ( subchr ( array, row*30+column ) );
}

// поместить данное item в массив array по координате [column, row]
item_to_array ( str array, int column, int row, int item )
{
  setchr ( array, row*30+column, item );
}

//------------------//----------------------//-------------------//--------//
// функция выводит на экран изображение спрайта
sprite_out ( int sprite_type )
{
 if ( sprite_type == s_free_place )
   pstra ( "  ", game_color );
 else if ( sprite_type == sb_free_place )
   pstra ( ". ", game_color );
 else if ( (sprite_type == s_man) or (sprite_type == sb_man) )
   pstra ( "><", game_color );
 else if ( (sprite_type == s_wall) or (sprite_type == sb_wall) )
   pstra ( "^178^178", game_color );
 else if ( sprite_type == s_box )
   pstra ( "<>", game_color );
 else if ( sprite_type == sb_box )
   pstra ( "^017^016", game_color );
}

//------------------//----------------------//-------------------//--------//
//
sprite_show ( int sprite_x, int sprite_y, int sprite_type )
{
 if ( item_from_array ( game_field, sprite_x, sprite_y ) == sb_box )
   if ( sprite_type != s_box )
     --score_new;

 if ( (item_from_array ( game_field, sprite_x, sprite_y )
                            & c_cntrl_bit ) != 0 )
   if (sprite_type == s_box )
     ++score_new;

 item_to_array ( game_field, sprite_x, sprite_y ,
   (item_from_array( game_field, sprite_x, sprite_y) & c_cntrl_bit)
   | (sprite_type) );

 // 5+3, 4+1 - смещения в home при выводе в окнышко
 gotoxy ( 5+3 + sprite_x*2, 4+1 + sprite_y );
 sprite_out ( item_from_array (game_field, sprite_x, sprite_y ));
}

//------------------//----------------------//-------------------//--------//
//
maze_init ()

{
 int i, j, crnt_char;

  //                    0        1         2         3
  //                    1234567890123456789012345678901
        maze         = "000000000000000000000000000000" ;
        strcat ( maze, "000000099999000000000000000000" );
        strcat ( maze, "000000090009000000000000000000" );
        strcat ( maze, "000000094009000000000000000000" );
        strcat ( maze, "000009990049990000000000000000" );
        strcat ( maze, "000009004004090000000000000000" );
        strcat ( maze, "000999090999090000099999900000" );
        strcat ( maze, "000900090999099999990033900000" );
        strcat ( maze, "000904004000000000000033900000" );
        strcat ( maze, "000999990999909199990033900000" );
        strcat ( maze, "000000090000009990099999900000" );
        strcat ( maze, "000000099999999000000000000000" );
        strcat ( maze, "000000000000000000000000000000" );

 // ---------------------------------- считывание лабиринта--------
 score_all = 0;
 score_new = 0;

 for ( i = 0; i < 13; ++i )
   for ( j = 0; j < 30; ++j )
     {
      item_to_array ( game_field, j, i, 0 );
          // сначала избавимся от мусора...
      crnt_char = item_from_array ( maze, j, i );
          // а теперь - от необходимости повторять правое выражение в
          // в каждом if-е
      if ( crnt_char == ь0ь )
        sprite_show ( j, i, s_free_place );
      else if (crnt_char == ь9ь)
        sprite_show ( j, i, s_wall );
      else if (crnt_char == ь4ь)
        sprite_show ( j, i, s_box );
      else if (crnt_char == ь3ь)
        {
         sprite_show ( j, i, sb_free_place );
         ++score_all;
        }
      else if (crnt_char == ь7ь)
        {
         sprite_show ( j, i, sb_box );
         ++score_all;
         ++score_new;
        }
      else if (crnt_char == ь1ь)
        {
         sprite_show ( j, i, s_man );
         man_x = j;
         man_y = i;
        }
      else if (crnt_char == ь2ь)
        {
         sprite_show ( j, i, sb_man );
         man_x = j;
         man_y = i;
         ++score_all;
        }
      else
        sprite_show ( j, i, s_free_place );
     }
}

//------------------//----------------------//-------------------//--------//
//
moving ( int dlt_x, int dlt_y )
{
       // а вот здесь обратим внимание на наличие скобок в выражениях
       // (SALT - это тот самый язык, где лишняя пара скобок не
       // повредит (sic! rules of precedence (то бишь, правила 
       // предшествования)))

 // свободно ли следующее поле?
 if ( (item_from_array( game_field, man_x+dlt_x, man_y+dlt_y)
      & c_bit_mask) == s_free_place )
   // перемещение двигателя на следующее поле
   {
    man_x = man_x + dlt_x;
    man_y = man_y + dlt_y;
   }
 else
   // проверим, может это - ящик?
   if ( (item_from_array ( game_field, man_x+dlt_x, man_y+dlt_y)
        & c_bit_mask) == s_box )
     // свободно ли поле за ящиком?
     if ( (item_from_array( game_field, man_x+(dlt_x*2),
          man_y+(dlt_y*2)) & c_bit_mask) == s_free_place )
       // переместим ящик и двигателя на поле в данном направлении
       {
        sprite_show ( man_x+dlt_x, man_y+dlt_y, s_free_place );
        sprite_show ( man_x+(dlt_x*2), man_y+(dlt_y*2), s_box );
        man_x = man_x + dlt_x;
        man_y = man_y + dlt_y;
       }
}

//------------------//----------------------//-------------------//--------//
//
game_round ()
{
 do {
   sprite_show ( man_x, man_y, s_man );
   kbrd_key = inkeyw ();

   sprite_show ( man_x, man_y, s_free_place );

   if ( kbrd_key == f_left )
     moving ( -1, 0 );
   else if (kbrd_key == f_right)
     moving ( 1, 0 );
   else if (kbrd_key == f_up)
     moving ( 0, -1 );
   else if (kbrd_key == f_down)
     moving ( 0, 1 );

  } while ( !( (score_new == score_all) or
             (kbrd_key == f_esc) or
             (kbrd_key == f_restart) ) );
}
//////////////////////////// the end ////////////////////////////////////////
```