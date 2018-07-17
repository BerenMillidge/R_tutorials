#testing R - yay following basic tutorials
print("hello world!")

# can assign with equals as wel?
x <- 10
print(x)
y = as.integer(3)
print(y)

# the as.type converts!
z <- 1 + 2i
print(z)

sqrt(-1 + 0i)

# character object is string in R
# for some reason vectors are created with c function
v <- c(2,3,5)
length(v)

# vectors can also be combined with c function
v2= c(6,7,8)
v3 = c(v, v2)
print(v3)


# all standard arithmetic operations are done elementwise on vectors/matrices. special functions for dot product and so forth!
# confusingly r will recycle values to add if different lengths rather than throwing an error
# so you should watch out for that!
# can give vectors in indices to slice
s <- c(1,2,3,4,4,5,6)
s[c(2,3)]
# uses numpy colon slicing notation
# yo ucan also slice with a logical index vector - which has same length and has true if member of original vector
# are to be included and false if not... might be useful at some point!?

# that's really cool... you can name vectors. i.e. create hashtables from the list i.e.
vec <- c(1,2)
names(vec) <- c("First", "Last")

# matrices are as expected
A <- matrix(c(2,3,3,1,5,7), nrow=2, ncol=3, byrow=TRUE)
A

# can extract elements using standard index synatx
A[2,3]
# whole column or row using nearly standard numpy synatx
A[1,] # order is rows, columns
A[,1]
# can also extract vetors of rows for instance i.e. first and third columns
A[, c(1,3)]
# that is cool, and very flexible... nice!