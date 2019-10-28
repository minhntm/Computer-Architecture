.data 
	inputString: .space 51
	recentStringList: .space 1000

	RESULT: .asciiz "RESULT:\n"
	INPUT_STRING_MESSAGE: .asciiz "Enter a string (under 50 character): "
	NOT_IS_PALINDROME_MESSAGE: .asciiz "This string is not a palindrome"
	IS_PALINDROME_MESSAGE: .asciiz "This string is a palindrome"
	STRING_IS_STORED_MESSAGE: .asciiz "This string is stored in memory!\n"
	FULL_MEMORY_MESSAGE: .asciiz "Full memory!!!\n"
	CONFIRM_MESSAGE: .asciiz "Do you want to continue?\n"
	FINISH_STORING_STRING_MESSAGE: .asciiz "Finish storing input string in memory!\n"
	TOO_LONG_STRING_MESSAGE: .asciiz "String too long!"
	ERROR: .asciiz "ERROR!!!\n"
.text
main:
#--------------------------------------------------------------------------------------------
# @brief	Nhan vao 1 xau tu nguoi dung
#--------------------------------------------------------------------------------------------
getString:
	li $v0, 54
	la $a0, INPUT_STRING_MESSAGE
	la $a1, inputString
	la $a2, 51
	syscall
#--------------------------------------------------------------------------------------------
# @brief		Tim do dai 1 xau
# @param[in]	$s0	Dia chi string can tim do dai
# @param[out]	$s1	Do dai cua string
# @param[out]	$t1	Chi so cua ki tu cuoi cung (Tinh tu 0)
#--------------------------------------------------------------------------------------------
getLength:
	la $s0, inputString
	addi $s1, $zero, 0	#s1 = length = 0
	addi $t1, $zero, 0	#t1 = i = 0
	findNullChar:
		add $t2, $s0, $t1	#t2 = pointer = inputString + i 
		lb $t3, 0($t2) 		#t3 = inputString[i]
		
		beq $t3, $zero,finishGetLength #if inputString[i] == '\0' -> finishGetLength
		
		addi $s7, $zero, 10
		beq $t3, $s7, updateString#if inputString[i] == '\n' -> bo di '\n'
		
		addi $s1, $s1, 1
		addi $t1, $t1, 1
		j findNullChar
	updateString:
		add $t1, $s0, $t1
		sb $zero, 0($t1)
	finishGetLength:
		add $t1, $zero, $s1 #i = length
		#i = length - 1 (dua i ve phan tu cuoi cung)
		addi $t1, $t1, -1 
#--------------------------------------------------------------------------------------------
# @brief		Kiem tra xem xau nhap vao co dai qua 49 khong
# @param[in]	$s1	Do dai cua inputString
# @param[out]		In ra thong bao neu dai hon 49
#--------------------------------------------------------------------------------------------		
isTooLongString:
	slti $t2, $s1, 50
	beq $t2, $zero, putErrorStringMessage
#--------------------------------------------------------------------------------------------
# @brief		Kiem tra xem xau nhap vao co trong recentStringList khong
# @param[in]	$s0	Dia chi cua inputString
# @param[in]	$s2	Dia chi cua recentStringList
# @param[out]	$t1	Chi so cua ki tu cuoi cung cua inputString (Tinh tu 0)
# @param[out]	$t8	Gia tri 0 hoac 1, 1 la inputString da co trong recentStringList
#					0 la chua co
#--------------------------------------------------------------------------------------------
isStoredInMemory:		
	la $s2, recentStringList
	addi $t2, $zero, 0	#t2 = j = 0
	addi $t8, $zero, 0	#t8 = check = 0
		traverseRecentStringList:
		add $t5, $s2, $t2 	#t5 = recentStringList + j
		lb $t5, 0($t5)
		beq $t5, $zero, finishTraverseRecentStringList
		
		slti $t4, $t2, 1000
		beq $t4, $zero, finishTraverseRecentStringList
		addi $t3, $zero, 0	#t3 = k = 0
		
		compareString:	
			#compare char of 2 string
			add $t6, $s2, $t2	#t6 = recentStringList + j
			add $t6, $t6, $t3	#t6 = t6 + k
			lb $t6, 0($t6)		#t6 = recentStringList[j+k]
			add $t7, $s0, $t3	#t7 = inputString + k
			lb $t7, 0($t7)		#t7 = inputString[k]
			bne $t6, $t7, notEqual	#inputString[k]!=recentStringList[j+k]='\0'->not equal
			beq $t6, $zero, isEqual #inputString[k]=recentStringList[j+k]='\0'->equal
			addi $t3, $t3, 1	#k++
			j	compareString
			
			isEqual:
				addi $t8, $zero, 1
				j finishTraverseRecentStringList
			notEqual: 
				addi $t2, $t2, 50
				j traverseRecentStringList
			
	finishTraverseRecentStringList:
#--------------------------------------------------------------------------------------------
	#if t8 = 1, thong bao da co string nay trong memory	
	bne $t8, $zero, putStringIsStoredMessage
			
#--------------------------------------------------------------------------------------------
# @brief		Kiem tra xem inputStringn co phai palindrome khong
# @param[in]	$s0	Dia chi cua inputString
# @param[in]	$s1	Do dai cua inputString
# @param[in]	$t1	Chi so cua ki tu cuoi cung cua inputString (Tinh tu 0)
# @param[out]		Thong bao ra man hinh
#--------------------------------------------------------------------------------------------		
add $t1, $zero, $s1
addi $t1, $t1, -1 
addi $t2, $zero, 0	#t2 = j = 0
checkPalindrome:		
		
	add $t3, $s0, $t2	#t3 = inputString + t2
	lb $t3, 0($t3)		#t3 = inputString[0]
	
	add $t4, $s0, $t1	#t4 = inputString + t1
	lb $t4, 0($t4)		#t4 = inputString[length]
	bne $t3, $t4, notIsPalindrome
	addi $t1, $t1, -1 	#i--
	addi $t2, $t2, 1	#j++
	slt $t5, $t2, $t1	#j < i?
	beq $t5, $zero, isPalindrome
	j checkPalindrome
	
	notIsPalindrome:
		la $a1, NOT_IS_PALINDROME_MESSAGE
		li $v0, 59
		la $a0, RESULT
		syscall
		j confirmDialog
		isPalindrome:
		la $a1, IS_PALINDROME_MESSAGE
		li $v0, 59
		la $a0, RESULT
		syscall
		j storeStringInMemory
#--------------------------------------------------------------------------------------------
# @brief		Luu tru inputString vao recentStringList
# @param[in]	$s0	Dia chi cua inputString
# @param[in] 	$s2	Dia chi cua recentStringList
# @param[in]	$s1	Do dai cua inputString
# @param[in]	$t1	Chi so cua ki tu cuoi cung cua inputString (Tinh tu 0)
# @param[out]		Thong bao da luu xau hoac loi do bo nho day
#--------------------------------------------------------------------------------------------	
storeStringInMemory:
	addi $t1, $s1, -1 	#t1 = i = length - 1
	addi $t2, $zero, 0 	#t2 = j = 0
	addi $t6, $zero, 0 	#t6 = k = 0
	findLastString:
		slti $t4, $t2, 1000
		beq $t4, $zero, putFullMemoryMessage	#j>1000 -> full memory
		add $t3, $s2, $t2	#t3 = recentStringList + j
		lb $t3, 0($t3)
		beq $t3, $zero, copyString #recentStringList[j] == '\0' -> copyString
		addi $t2, $t2, 50	#j = j + 50
		j findLastString
	copyString:
		slt $t5, $t1, $t6
		bne $t5, $zero, putFinishedStoreString
		add $t7, $t2, $t6	#t7 = j + k
		add $t7, $t7, $s2	#t7 = t7 + recentStringList
		add $t8, $t6, $s0	#t8 = t6 + inputString
		lb  $t8, 0($t8)
		sb $t8, 0($t7)		#recentStringList[j+k] = inputString[k]			
		addi $t6, $t6, 1	#k++
		j copyString
#--------------------------------------------------------------------------------------------
# @brief		Hien ra cac message
# @param[out]		In message ra console hoac man hinh
#--------------------------------------------------------------------------------------------	
putFinishedStoreString:	
	li $v0, 4
	la $a0, FINISH_STORING_STRING_MESSAGE
	syscall
	j confirmDialog
	
putStringIsStoredMessage:
	li $v0, 4
	la $a0, STRING_IS_STORED_MESSAGE
	syscall
	
	li $v0, 59
	la $a1, IS_PALINDROME_MESSAGE
	la $a0, RESULT
	syscall
		
	j confirmDialog			
		
putFullMemoryMessage:
	li $v0, 4
	la $a0, FULL_MEMORY_MESSAGE
	syscall
	j confirmDialog
	
putErrorStringMessage:
	la $a1, TOO_LONG_STRING_MESSAGE
	li $v0, 59
	la $a0, ERROR
	syscall
	j main
#--------------------------------------------------------------------------------------------
# @brief		Nhan xem nguoi dung co muon tiep tuc nhap khong
#			Chi khi an yes moi cho nhap tiep
# @param[out]	$a0	0: Yes
#			1: No
#			2: Cancel
#--------------------------------------------------------------------------------------------		
confirmDialog:
	li $v0, 50
	la $a0, CONFIRM_MESSAGE
	syscall
	beq $a0, $zero, main
	
