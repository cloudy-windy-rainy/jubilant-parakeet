def mux_4x1(s2,s1):
    s2_not = not(s2)
    s1_not = not(s1)
    AND_4 = s1_not& s2_not & d1
    AND_3 = s1_not&s2&d2
    AND_2 = s1&s2_not&d3
    AND_1 = s1&s2&d4

    Y = AND_1|AND_2|AND_3|AND_4

    return Y

d1 = 1; d2 = 2; d3 = 3; d4 = 4;

print(mux_4x1(0,0))
print(mux_4x1(0,1))
print(mux_4x1(1,0))
print(mux_4x1(1,1))


def demux_4x1(s1,s2):
    y = 0
    y_not = not(y)
    s1_not = not(s1)
    s2_not = not(s2)
    d1 = s1_not & s2_not & y_not
    d2 = s1_not &s2 & y_not
    d3 = s1 & s2_not & y_not
    d4 = y_not &s1&s2


    return d1, d2, d3, d4

print(demux_4x1(0,0))
print(demux_4x1(0,1))
print(demux_4x1(1,0))
print(demux_4x1(1,1))

