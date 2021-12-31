print('hello world')


def half_adder(A,B):
    half_out = A^B
    carry = A&B
    return half_out, carry

print(' A B  S  C ')
print(' 0 0',half_adder(0,0))
print(' 0 0',half_adder(0,1))
print(' 0 0',half_adder(1,0))
print(' 0 0',half_adder(1,1))
