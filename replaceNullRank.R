# Replaces all NA values in the "Rank" column of a datatable. Useful when there are ties in the recordbook
replaceNullRank <- function(dataTable) {
  for(i in 1:nrow(careerPoints)) { # nrow gets the number of rows in the datatable
    if(is.na(dataTable["Rank"][i,])) {
      dataTable["Rank"][i,] = dataTable["Rank"][i-1,] # if there's an NA value, replace it with the previous rank because there's a tie in the recordbook. 
    }
    else { # else, do nothing
      
    }
  }
  return(dataTable) # return the fixed dataTable
}