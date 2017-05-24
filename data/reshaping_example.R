## tidyr() example
library(tidyr)

## Example data
df <- data.frame(
        id = 1:10,
        time = as.Date('2009-01-01') + 0:9,
        Q3.2.1. = rnorm(10, 0, 1),
        Q3.2.2. = rnorm(10, 0, 1),
        Q3.2.3. = rnorm(10, 0, 1),
        Q3.3.1. = rnorm(10, 0, 1),
        Q3.3.2. = rnorm(10, 0, 1),
        Q3.3.3. = rnorm(10, 0, 1)
)
## Print df to console
df
## Reshape data
df%>%gather(key, value, -id, -time)%>%
        extract(key, c("question", "loop_number"), "(Q.\\..)\\.(.)")%>%
        spread(question, value)

