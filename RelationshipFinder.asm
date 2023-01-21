############## Krish Israni ##############
############## 113227084 #################
############## kisrani ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_term ############################################################
create_term:

beqz $a0, invalid
bltz $a1, invalid


move $s1, $a0

li $a0, 4
li $v0, 9
syscall

sw $s1, 0($v0)

li $a0, 4
li $v0, 9
syscall

sw $a1, 0($v0)

li $a0, 4
li $v0, 9
syscall

li $t0, 0
sw $t0, 0($v0)

addi, $v0, $v0, -8
li $s1, 0
  jr $ra

invalid:
li $v0, -1
  jr $ra


.globl create_polynomial ############################################################
create_polynomial:
# $t0 - Counter for number of terms
# $t1 - Value read
# $t2 - Max exponent
# $t3 - Exponent read
# $t4 - Exponent incrementer for max coeffecient
# $t5  - Counter for number of coeffecients
# $t6 - temp counter to find repeats
# $t7 - -1
# $t8 - scrolling sp read
# $t9 - address incrementer

# $s1 - used for scrolling through sp
# $s2 - total for coeffecients
# $s3 - first term
# $s4 - second term
# $s5 - prior max exponent
# $s6 - Counter for n
# $s7 - Starting address


li $t0, 0 
li $s5, -1
Next_term:
blez $a1, no_check_counter
beq $a1, $s6, pol_done
no_check_counter:
addi $t9, $a0, 4

li $t2, -1 
li $t5, 0 
li $t7, -1
li $s2, 0 

next_in_array:
lw $t1, 0($t9) # load digit

bne $t1, $t7, not_end # checking if end of array
lw $t1, -4($t9)
beqz $t1, end
##

not_end:

ble $t1, $t2, less # checking if exp is greater

bltz $s5, dontcheck
bge $t1, $s5, different_exp
dontcheck:
move $t2, $t1

##
li $t6, 4
mul $t5, $t5, $t6
add $sp, $sp, $t5
li $t5, 0


less:

bne $t1, $t2, different_exp # checking if exp is equal

lw $t1, -4($t9) #load coeffecient
li $t6, 0

move $s1, $sp
look_for_repeat:


beq $t6,$t5, done_checking
lw $t8 0($s1)
beq $t8, $t1, different_exp
addi $s1, $s1, 4
addi $t6, $t6, 1
j look_for_repeat


done_checking:
addi $sp, $sp, -4
addi $t5, $t5, 1
sw $t1, 0($sp)
addi $t9 $t9, 8
j next_in_array


different_exp:
addi $t9,$t9, 8
j next_in_array



end:


bltz $t2, pol_done

blez $a1, no_check_n
beq $a1, $s6, added # when counter = null
no_check_n:

move $s5, $t2
beqz $t5, added
lw $t1, 0($sp)
add $s2, $t1, $s2
addi $sp, $sp, 4
addi $t5, $t5, -1
addi, $s6, $s6, 1####
j end

added:

addi $sp, $sp, -40
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $s2, 12($sp)
sw $s3, 16($sp)
sw $s4, 20($sp)
sw $s5, 24($sp)
sw $s6, 28($sp)
sw $s7, 32($sp)
sw $t0, 36($sp)
move $a1, $t2
move $a0, $s2
jal create_term

lw $ra, 0($sp)
lw $a0, 4($sp)
lw $a1, 8($sp)
lw $s2, 12($sp)
lw $s3, 16($sp)
lw $s4, 20($sp)
lw $s5, 24($sp)
lw $s6, 28($sp)
lw $s7, 32($sp)
lw $t0, 36($sp)
addi $sp, $sp, 40

move $s4, $s3
move $s3, $v0

beqz $t0, skip

sw $s3, 8($s4)

skip:

bnez $t0 dont_save_first

move $s7, $s3

dont_save_first:
addi $t0, $t0, 1
j Next_term

pol_done:

li $a0, 8
li $v0, 9
syscall

sw $s7, 0($v0)
sw $t0, 4($v0)


li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
li $s7, 0

jr $ra

.globl add_polynomial ###################################################################
add_polynomial:

# $s0 - address for linked list 1
# $s1 - number of terms for 1
# $s2 - address for linked list 2
# $s3 - number of terms for 2
# $s4 - adress for added polynomial
# $t0 - read exp value of linked list 1
# $t1 - read exp value of linked list 2
# $t2 - read coef value of linked list 1
# $t3 - read coef value of linked list 2
# $t4 - sum of coeffecients if equal
# $t5 - counter for number of terms


lw $s0, 0($a0)
beqz $s0, is_null
lw $s1, 4($a0)
lw $s2, 0($a1)
beqz $s2, is_null
lw $s3, 4($a1)
li $t5, 0



add_next_term:




bnez $s1, still_add
beqz $s3, done_adding_both
still_add:


beqz $s1, less_than
beqz $s3, greater_than


lw $t0, 4($s0)
lw $t1, 4($s2)

beq $t0, $t1, equal_to
blt $t0, $t1, less_than
bgt $t0, $t1, greater_than

equal_to:


lw $t2, 0($s0)
lw $t3, 0($s2)
add $t4, $t2, $t3

beqz $t4, null_coef

li $a0, 8
li $v0, 9
syscall
sw $t4, 0($v0) 
sw $t0, 4($v0) 

bnez, $t5, do_not_save_head
move $s4, $v0
do_not_save_head:


addi $t5, $t5, 1
null_coef:

addi $s1, $s1, -1
addi $s3, $s3, -1
addi $s0, $s0, 12
addi $s2, $s2, 12

j add_next_term

less_than:

lw $t3, 0($s2)
li $a0, 8
li $v0, 9
syscall
sw $t3, 0($v0) 
sw $t1, 4($v0) 
bnez, $t5, do_not_save_head2
move $s4, $v0
do_not_save_head2:
addi $s3, $s3, -1
addi $s2, $s2, 12
addi $t5, $t5, 1
j add_next_term

greater_than:

lw $t2, 0($s0)
li $a0, 8
li $v0, 9
syscall
sw $t2, 0($v0) 
sw $t0, 4($v0) 
bnez, $t5, do_not_save_head3
move $s4, $v0
do_not_save_head3:
addi $s1, $s1, -1
addi $s0, $s0, 12
addi $t5, $t5, 1
j add_next_term


done_adding_both:

beqz $t5, is_null

lw $t0, 0($s4)
beqz $t0, is_null

li $a0, 8
li $v0, 9
syscall

li $t2, 0
li $t0, -1

sw $t2, 0($v0) 
sw $t0, 4($v0)
 
 
li $a0, 4
li $v0, 9
syscall
sw $t5, 0($v0) 

addi $sp, $sp, -12
sw $a0 0($sp)
sw $a1 4($sp)
sw $ra 8($sp)

move $a0, $s4
move $a1, $v0

jal create_polynomial
lw $a0 0($sp)
lw $a1 4($sp)
lw $ra 8($sp)
addi $sp, $sp, 12

li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
li $s7, 0
  jr $ra

is_null:
li $v0, 0

li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
li $s7, 0
  jr $ra
  
.globl mult_polynomial
mult_polynomial: #############################################################################

# $s0 - address for linked list 1
# $s1 - number of terms for 1
# $s2 - address for linked list 2
# $s3 - number of terms for 2
# $s4 - $sp original
# $s5 - $sp original (for moving)



lw $s0, 0($a0)
beqz $s0, null
lw $s1, 4($a0)
lw $s2, 0($a1)
beqz $s2, null
lw $s3, 4($a1)
move $s4, $sp
move $s5, $sp




multiply_next_set:
beqz $s1, done_multiplying
lw $t0, 0($s0)
lw $t1, 4($s0)


lw $s2, 0($a1)
lw $s3, 4($a1)

multiply_each_term:
beqz $s3, go_to_next_set

lw $t2, 0($s2)
lw $t3, 4($s2)

mul $t4 $t0 $t2
add $t5 $t1 $t3
addi $sp, $sp , -4
sw $t4, 0($sp)
addi $sp, $sp , -4
sw $t5, 0($sp)


lw $s2, 8($s2)
addi $s3, $s3, -1

j multiply_each_term

go_to_next_set:
lw $s0, 8($s0)
addi $s1, $s1, -1
j multiply_next_set

done_multiplying:###########
# $s6 - address of head
# $s7 - counter for terms
# $t8 - -2


li $s7, 0
li $t8, -2



Next_round:
beq $sp, $s5, done_coef_adding
lw $t0, -4($s5)
lw $t1, -8($s5)
beq $t1, $t8, number_done


addi $s6, $s5, -8

check_repeats:
beq $sp, $s6, next

lw $t2, -4($s6)
lw $t3, -8($s6)
beq $t3, $t8, not_equal

bne $t1, $t3, not_equal
add $t0, $t0, $t2
sw $t8, -8($s6)


not_equal:

addi $s6, $s6, -8
j check_repeats

next:

beqz $t0, skip_term


addi $sp,$sp, -4
sw $a0, 0($sp)
li $a0, 8
li $v0, 9
syscall
lw $a0, 0($sp)
addi $sp,$sp, 4

sw $t0, 0($v0)
sw $t1, 4($v0)
bnez $s7, dont_save_initial
move $s0, $v0

dont_save_initial:
addi $s7, $s7, 1
skip_term:
number_done:
addi $s5, $s5, -8
j Next_round

done_coef_adding:########


addi $sp,$sp, -4
sw $a0, 0($sp)
li $a0, 8
li $v0, 9
syscall
lw $a0, 0($sp)
addi $sp,$sp, 4
li $t0, 0
li $t1, -1

sw $t0, 0($v0)
sw $t1, 4($v0)


addi $sp, $sp, -16

sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 8($sp)
sw $s4, 12($sp)
move $a0, $s0
move $a1, $s7
jal create_polynomial
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 8($sp)
lw $s4, 12($sp)
addi $sp, $sp, 16

move $sp, $s4
li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
li $s7, 0
  jr $ra

null:
move $sp, $s4
li $v0, 0

li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
li $s7, 0

  jr $ra
