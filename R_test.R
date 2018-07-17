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

# a list is a heterogeneous data structure which can contain objects of any ttpe
# slice with square brackets, which just creates a new list with one element
x <- list(1,2,"three")
x[2]
# to get the actual member use double square bracket
x[[2]]

# lists can also have named references like vectors

# a dataframe is often the key structure for storing tables of data. It is a list of vectors
# each element in the list is a different column of the table, this means that the columns can have 
# arbitrary type but the type of each column element needs to be the same
# which is precisely what makes sense for most data tables
# created by data.frame function i.e.
n <- c(2,3,4)
s <- c("a", "b", "c")
b <- c(TRUE, FALSE, TRUE)
df <- data.frame(n,s,b)
df


# built in dataframes
mtcars[1,2]
head(mtcars)

nrow(mtcars)

# so yeah r allows lots of easy analysis on data frames and very useful methods to create these things
# does not seem difficult at all which is nice!
mtcars[["mpg"]] #use double square bracket notation to get the actualvalue of the column
# can access dataframe column by name or by index
mtcars[[2]] # double index notation both times
# single index notation gets you a column slice
mtcars[1]
# this gets you the row labels as well, instead of just the values
#can get multiple slices by giving it a vector
mtcars[c(1,2)]
# you can get row indexes too using a comma index
mtcars[1,]

demo(graphics)
