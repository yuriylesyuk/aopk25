## Часть I. Введение. Технология взлома


Если Вы хотите научиться плавать, - плавайте, если вы хотите научиться
говорить по-английски, - разговаривайте. Народная мудрость. Я захотел
научиться писать компьютерные игрушки коммерческого качества. И мне
ничего другого не оставалось, как сделать это.

Конечно, фирмы-изготовители игрушек не очень-то рекламируют свои
исходные тексты. Ну что же, для такого случая и существует Sourser.
Безусловно, комментарий, который выдает этот дизассемблер, можно считать
комментарием лишь с большой натяжкой. Ну что ж, для настоящего
программиста ассемблерный код - самоочевиден.


Наверное самым сложным из всего, что случилось за те несколько недель, в
которые проходила работа, было выбрать саму игрушку. С одной стороны,
не хотелось огорчать фирму, секреты которой я невольно приоткрою.
С другой: уж если ломать, то такое, чтобы самому было и приятно и
полезно.

Выбор пал на "Капитана Комика" американца Майкла Денио ( Captain Comic
by Michael Denio ).

По многим причинам. Это одна из самых симпатичных мне аркадных игрушек
( arcade game ). У нее классические характеристики:

	- экран 320 х 200, 16 цветов;
	- сюжетное построение;
	- стандартный набор музыкальных возможностей: фоновое
	  сопровождение, спец. эффекты,

и, что немаловажно, хорошо развиты графические возможности ( спрайтовая
графика, мультипликаты ).

Что окончательно склонило выбор в пользу данного представителя
капиталистического рынка программного обеспечения: у нее, что редко
встречается движущееся панорамирование игрового пространства
(согласитесь, мало того, что этот эффект просто смотрится, даже на глаз
можно сказать, что сделать это не так-то просто.).

Конечно, это уже старая игрушка - еще 1989-го года. Но если внимательно
проанализировать более свежих представителей этого жанра, то можно
заметить, что по сути дела они становятся более изощренными ( 256
цветов, реалистическая графика и динамика поведения персонажей,
совершенее звуковое сопровождение (real sound) ). Но сам набор
возможностей большого количества компьютерных игрушек функционально
покрывается имеющимся в "Капитане Комике".


Самая важная причина, по которой мне хотелось разобраться в компьютерных
играх: удручающий дилетантизм в методической литературе, посвященной им:
общие рассуждения, примитивные примеры...

Результатом многочасовой ( и даже - многодневной! ) работы и является
следующий цикл статей, который можно было бы подзаглавить "Техника
реализации функциональных элементов компьютерных игрушек. Продвинутый
этап ( advanced period ).


В данной статье мы кратко познакомимся с основными особенностями
процесса взлома компьютерных игрушек.

Немного остановимся на конкретных трудностях и путях их преодоления.

Перечислим функциональные подсистемы "Капитана Комика" и пообещаем более
полно рассказать об этих подсистемах в следующих статьях цикла.


Первое, с чего нужно начинать взламывать компьютерную игрушку - это
получение двоичной копии опаративной памяти, содержащей в себе
работающую программу, так называемый слайд выполнения (execution slide).

Аргументов здесь несколько.

Один из основных, - упаковка программ DOS-овской утилитой EXEPACK. Что
это значит для  программиста: что он имеет возможность уменьшить
количество места, требуемого для хранения своей программы, кроме того,
уменьшается время загрузки программы с диска и все это за счет сжатия
областей, заполненных последовательностями одинаковых байтов в
специальный формат.

(Во время запуска такого файла на выполнение, сначала отрабатывается
фрагмент, раскручивающий закодированный формат, и уже затем управление
передается самой программе.)

Для взломщика же это означает, что почти весь полученный после
дизассемблирования загрузочного модуля текст игрушки оказывается
непригодным для анализа.

Часть данных интерпретируется, как программный код.
Часть же  адресов и смещений полностью теряет свой смысл: информация
по этим адресам не соответствует действительности.

Вот в этот момент и можно по достоинству оценить преимущество
формирования ссылки в командах перехода 86 ассемблера относительно
точки перехода: благодаря этому большие куски программы оказываются
корректными!

Поскольку в нашем дизассемблерном листинге и так будет много темных
мест, не стоит усугублять себе задачу лишней работой (то есть, пытаться
дизассемблировать текст загрузочного модуля).

Лучше подумать над тем, как быстро сделать слайд программы.

Трассировать упакованную игрушку - бесполезно: можно часами созерцать
как EXEPACK-овский раскрутчик повторяет один и тот же цикл.

Вычислить же начало истинной программы не всегда возможно. Кроме того,
ставить точки прерывания по некоторым причинам (далее - более подробно)
часто невозможно.

Один из вариантов: когда я проанализировал начало Комика, то по
контексту (встретился код операции открытия файла) обнаружил, что Комик
довольно таки просто обрабатывает необходимые ему вспомогательные
файлы. Если операция открытия файла возвращает ошибку, Комик
восстанавливает адреса прерываний и возвращается в систему.

Дальше все просто: уничтожив файл, содержащий экран заставки, запускаю
(по Go) в отладчике Комика. Я действительно оказываюсь на нужном адресе.
Остальное - дело техники и команды записи файла (W) отладчика, и готов
файл - слайд памяти.

	Для попадания внутрь работающей программы с целью получить слайд
	памяти существует один довольно таки интересный способ: если мы
	запускаем отладчик AFD в резидентный режим, а после запуска на
	выполнение отлаживаемой (читай - взламываемой) программы
	нажимаем Ctrl-ESC (код для выхова AFD), то последний честно
	перехватывает управление и, ломая графику и адреса векторов
	прерываний, дает нам возможность записать память не диск.

Другой аргумент получения слайда памяти выполнения программы, он же -
ьнекоторая причина невозможности трассировки программыь, упомянутая выше,
- INT 3. Оказывается, по тексту программы раскидан INT 3! А через INT 3,
оказывается, Комик работает со своим музыкальным монитором.

Для тех счастливцев, кто не знает, что такое INT 3, объясняю:
программные прерывания как таковые ( а INT 3 является программным
прерыванием), грубо говоря, эквивалент подпрограмм. Все прерывания -
двухбайтные. Но одно сделано обнобайтным. Это INT 3. Предназначено оно
для целей организации отладчиками процесса работы с точками
остановов: с адреса точки останова отладчик списывает байт, и на место
этого байта записывается код INT 3. По самому же INT-у ставится переход
на отладчик. Далее по команде Go пользовательской программе передается
управление, и последняя работает до тех пор пока не достигает команды
INT 3, которая и возвращает управление отладчику.

Очень удобно, особенно если учесть, что один байт это все таки не 2.
Вот это удобство и используют все отладчики.

При запуске Комика, последний изменяет содержимое адреса прерывания
INT 3, что в отладчике и приводит к зависанию машины.

	Конечно, с точки зрения Майкла Денио, это быть может и кажется
	остроумной защитой от взламывания, я же поняв, что услугами
	отладчиков мне уже воспользоваться не придется, хорошей такую
	идею счесть, безусловно, не мог.

Еще одно рассуждение о пользе слайдов памяти: многие предварительные
установки, инициализации исходных переменных, фиксации состояний игры,
будучи зафиксированными на слайдах памяти, оказывают дополнительную
помощь в процессе осмысливания, то есть, восстановления смысла работы
программы.

После того, как мы получаем слайд выполняемой памяти программы, к нашим
услугам прекрасная программа - Sourser (дай бог здоровья ее создателям:
скольким программистам они сьекономили и его и времени!).

Все, что происходит между получением листинга после Sourser-a и перед
окончательным редактированием взламываемой вами программы - покрыто
мраком. Это работа творческая. Одно могу отметить точно: тот, кто
сказал, что проще написать свою программу, чем разобраться в чужой, явно
приврал: на самом деле написать свою программу в такой ситуации во много
раз (!!!) проще, а не просто ьпрощеь.

	Общими словами здесь, конечно, не обойтись, поэтому многие из
	встретившихся ситуаций психологической интерпретации кода будут
	проанализированы и описаны в следующих статьях, на конкретных
	примерах.

Основное правило разбора в непрокомментированных текстах: после того,
как получен листинг дизассемблера, компьютер до-о-лго не требуется:
достаточно только стол и ручка.

Еще раз вернемся к процессу трассировки. Да, безусловно, во многих
случаях трассировка как таковая, во много раз повышает эффективность
анализа программы. Видеть, что можно проверить свою гипотезу
одной-единственной точкой останова и не иметь такой возможности, ну
оч-чень обидно!

Возможность достойно выйти из такой ситуации дает прекрасный отладчик
PERISCOPE. Чем же этот отладчик так прекрасен?

Он позволяет реализовывать пользовательские прерывания (user interrupt).
В частности, одно из написанных мною прерываний организует программую
точку останова через нужный мне двухбайтный INT. (О технике работы с
точками останова было рассказано выше.)

Другое свое (пользовательское) прерывание, которым я часто пользуюсь
позволяет мне отлаживать программы, используемые графические режими. В
чем дело? Если Вы отлаживали хоть какую-то графическую программу, Вы не
могли не заметить: вернулись в отладчик, вернулись в программу, а на
экране - грязные пятна вместо половины экрана...

Диагноз прост: одладчик пользуется той же ОЗУ-ой (оперативной памятью),
что и наша программа.

Курс лечения не намного сложнее: возвращаем прерывание отладчику после
того, как скопируем в буфер фрагмент ОЗУ экрана пользовательской
программы, который портится, после отладчика - восстанавливаем это ОЗУ.


И последнее, но не маловажное, о чем бы хотелось сказать. Об 
инструменте, который должен быть в арсенале взломщика программ, то есть, 
настоящего программиста. Значение его (инструмента) трудно даже и 
переоценить: он как фомка, как отмычка (для другого взломщика.

Инструмент этот: таблица, в порядке возрастания кодов то второй колонке 
которой соответствующая им ассемблерная команда.

	Для 86-го процессора - попытайтесь вспомнить - такой таблицы 
	нет, а ведь после дизассемблера - попробуйте возразить - нередко 
	приходится самому поработать дизассемблером.

Изготовить такую штуку, конечно, просто. в отладчике набираем строки:

	00 90 90 90 90 90
	01 90 90 90 90 90 
	02 90 90 90 90 90
	...
	ff 90 90 90 90 90

Эти нопы, естественно, нужны, потому что первый байт в команде - не 
обязательно единственный. А дальше - дизассемблируем (по U) набранный 
текст, и наша фомка - готова!



Музыкальный проигрыватель. Статья посвящается технической стороне 
реализации музыкального сопровождения в игрушке "Капитан Комик". 

Кратко рассмотрен процесс звукоизвлечения при помощи компьютера. 
Рассказано о нюансах, связанных с необходимостью получать звук в фоновом 
режиме. Впрочем, эту информацию мы можем почерпнуть и из других 
литературных источников (список которых, конечно же, приводится).

Более интересным является рассмотрение процесса взаимодействие 
музыкальной части с остальной программой игры: технология запуска 
мелодий, включение/отключение звука, реализация механизма приоритера 
мелодий, получение программой информации о состоянии мелодии.

Материал полностью проиллюстрирован листингами, блок-схемами. Кроме 
того, приводится реализация функций, позволяющий организовать 
музыкальное сопровождение в любой пользовательской системе. 

Как пример, дается драйвер музыкального проигрывателя для систем, 
написанных на языке dBASE и ему подобных.


Драйвер ввода. Клавиатура. Немаловажный момент: процесс ввода информации 
в машину приобретает особое значение в игрушках.

Статья рассматривает вопросы опроса клавиатуры, проблемы фиксации 
нажатия/отпускания различных клавиш. Анализируются проблемы ввода 
информации с устройств типа джойстик/мышь. Приведены реализации конечных 
автоматов, позволяющих организовать функциональное соответствие 
устройств клавиатуре.

Конечно, все проиллюстрировано фрагментами программ, рисунками.


Драйверы графики: заставки, спрайты, панорамирование. Пожалуй, самый 
ответственный момент любой компьютерной игры - графика.

И каких только технических ухищрений не используют при работе с экраном. 
Ведь счет времени идет на миллисекунды! Некоторые из этих ухищрений 
рассматриваются в данной статье. Анализируемые примеры и программы 
реализуют графические драйвера для адаптеров типа EGA/VGA.

Описаны процессы реализации спрайтовой графики. Приведены примеры 
анализа функциональной части игры, и коды программ, в которые выливается 
этот анализ (здесь, в частности, и рассмотрено панорамирование).

Далее рассматриваются спецэффекты графики: мультипликация (явление 
Комика не пранету, дематериализация Комика), мигание (призы в уголке 
экрана), взблескивание (в первом и втором экранах заставки).

Безусловно, техническая информация о графических адаптерах, операционной 
системе только повышает полезность статьи.


Технология программирования компьютерной игры: идея, сюжет, реализация.
Пожалуй, самое интересное, о чем реже всего предпочитают говорить книги 
и учебники, это организация работы при проектировании и программировании 
самой компьютерной игры.

Приводится примерный план процесса реализации игрушки с учетом всех 
технических этапов; для каждого этапа приводится инструментарий, 
позволяющий облегчать построение элементов игры (графические/музыкальные 
редакторы, мультипликаторы, встроенные средства отладки игр, 
специализированные языки программирования игрушек и т.п.).

Здесь происходит знакомство с функциональной схемой работы "Капитана 
Комика", основными ее элементами. Приводится специфика отладки программ, 
работающих в режиме реального времени и реализующих динамику и элементы 
многопроцессности.

Воссозданная последовательность поэтапной работы над программой "Капитан 
Комик", а также расклад работ по времени завершают изложение.

