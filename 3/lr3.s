main:
  movb    $0, r0          # Остаток R = 0
  movb    $0, r1          # Результат Q = 0

  movl    #22, r6         # r6 указывает на A
  movl    #23, r7         # r7 указывает на B
  movb    (r6), r2        # Загружаем A в r2
  movb    (r7), r3        # Загружаем B в r3

  cmpl    r0, r3          # Сравниваем R с B
  bge     overflow        # если R >= B, переходим в overflow

  movb    $3, r4          # i = 3

i_loop:
  sll     $1, r0, r0      # R = (R << 1)
  movb    r2, r5          # Кладём A в r5
  srl     r4, r5, r5      # Сдвигаем r5 вправо на i позиций
  andb    $1, r5, r5      # Получаем крайний правый бит r5

  bisb    r5, r0, r0      # R = (R << 1) | ((A >> i) & 1)

  cmpb    r0, $0          # Сравниваем R с 0
  blssu    plus_b          # Если R < 0, прыгаем в plus_b

  subb3   r3, r0, r0      # Уменьшаем R на B
  brb     cont

plus_b:
  addb3   r3, r0, r0      # Увеличиваем R на B
  brb     cont

cont:
  sll     $1, r1, r1      # Q = Q << 1 (Сдвигаем Q влево на 1)

  cmpb    r0, $0          # Снова сравниваем R с 0
  blssu    dec_i_and_check # Если меньше, то перепрыгиваем инкрементацию Q 
  addb2   $1, r1          # Иначе увеличиваем Q

dec_i_and_check:
  subb2   $1, r4          # i -= 1
  cmpb    r4, $0          # Проверяем что i >= 0
  bge     i_loop          # если да, прыгаем назад, иначе идём дальше

  movl    #24, r6         # r6 указывает на result
  movb    r1, (r6)+       # Сохраняем Q в память и инкрементируем r6

  # movl    #25, r6         # r6 указывает на remainder
  movb    r0, (r6)+       # Сохраняем R в память и инкрементируем r6

print_result:
  movb    $0, r0          # Успешное завершение
  HALT

overflow:
  movb    $1, r0          # Переполнение - деление невозможно
  halt                    # Останавливаем выполнение
