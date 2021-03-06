print('hello world')

#half_adder
#Half_out : A XOR B (Sum same number input : 0/ Sum diffent number input : 1)
#carry : A AND B [(binary) 1+1 = 10, carry occured 

def half_adder(A,B):
    half_out = A^B
    carry = A&B
    return half_out, carry

print(' A B  S  C ')
print(' 0 0',half_adder(0,0))
print(' 0 0',half_adder(0,1))
print(' 0 0',half_adder(1,0))
print(' 0 0',half_adder(1,1))



#full adder
#combine two half-adder module

def full_adder(A,B,C):
    half_out, carry = half_adder(A,B)
    full_out = half_out^C
    c_out = half_out & C|(A&B)
    return full_out, c_out

print(' A B c  S  C ')
print(' 0 0 0',full_adder(0,0,0))
print(' 0 0 1',full_adder(0,0,1))
print(' 0 1 0',full_adder(0,1,0))
print(' 0 1 1',full_adder(0,1,1))
print(' 1 0 0',full_adder(1,0,0))
print(' 1 0 1',full_adder(1,0,1))
print(' 1 1 0',full_adder(1,1,0))
print(' 1 1 1',full_adder(1,1,1))



# subtraction
# half_out = A XOR B ( Sub same number input : 0/ Sub diffent number input : 1)
# borrow = 0-1, there's no negative number in binary. It need 1 to subtract 1.
# You Should change 0 to 1. 'not(A)'
# then you can solve the problem with not_A

def half_sub(A,B):
    half_out = A^B
    not_A = not(A)
    borrow = not_A&B
    return half_out, borrow

#full subtraction
# you can make full sub module with two subtraction modules.

def full_sub(A,B,B_in):
    half_out, borrow = half_sub(A,B)
    full_out = half_out^B_in
    not_half = not(half_out)
    B_out= half_out & B_in|borrow
    return full_out, B_out

print('A B Bin  S Bout')
print('0 0 0  ',full_sub(0,0,0))
print('0 0 1  ',full_sub(0,0,1))
print('0 1 0  ',full_sub(0,1,0))
print('0 1 1  ',full_sub(0,1,1))
print('1 0 0  ',full_sub(1,0,0))
print('1 0 1  ',full_sub(1,0,1))
print('1 1 0  ',full_sub(1,1,0))
print('1 1 1  ',full_sub(1,1,1))
print('0 0 0  ',full_sub(0,0,0))


