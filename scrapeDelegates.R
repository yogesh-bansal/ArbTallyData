source("helperfuncs.R")

#################################################################################
## Loop Scrape Delegates
#################################################################################
variables <- list(
                    "input" = list(
                                    "filters"=list("governanceId" = "eip155:42161:0xf07DeD9dC292157749B6Fd268E37DF6EA38395B9"),
                                    "sort"=list("isDescending" = TRUE,"sortBy" = "DELEGATORS"),
                                    "page"=list("limit" = 20)
                              )
              )

resp <- con$exec(qry$queries$delegatedata,variables=variables)

delegatesdf <- data.frame(
                            Address = fromJSON(resp)$data$delegates$nodes$account$address,
                            Name = fromJSON(resp)$data$delegates$nodes$account$name,
                            ENS = fromJSON(resp)$data$delegates$nodes$account$ens,
                            votesCount = fromJSON(resp)$data$delegates$nodes$votesCount,
                            delegatorsCount = fromJSON(resp)$data$delegates$nodes$delegatorsCount
                          )

while(TRUE)
{
  variables <- list(
                    "input" = list(
                                    "filters"=list("governanceId" = "eip155:42161:0xf07DeD9dC292157749B6Fd268E37DF6EA38395B9"),
                                    "sort"=list("isDescending" = TRUE,"sortBy" = "DELEGATORS"),
                                    "page"=list("limit" = 20,"afterCursor" = fromJSON(resp)$data$delegates$pageInfo$lastCursor)
                              )
              )
  resp <- con$exec(qry$queries$delegatedata,variables=variables)
  delegatesdft <- data.frame(
                            Address = fromJSON(resp)$data$delegates$nodes$account$address,
                            Name = fromJSON(resp)$data$delegates$nodes$account$name,
                            ENS = fromJSON(resp)$data$delegates$nodes$account$ens,
                            votesCount = fromJSON(resp)$data$delegates$nodes$votesCount,
                            delegatorsCount = fromJSON(resp)$data$delegates$nodes$delegatorsCount
                          )
  delegatesdf <- rbind(delegatesdf,delegatesdft)
  message(paste0(length(unique(delegatesdf$Address)),"  :  ",round(as.numeric(tail(fromJSON(resp)$data$delegates$nodes$votesCount,1))/(10^18)),"  :  ",tail(fromJSON(resp)$data$delegates$nodes$delegatorsCount,1)))
}
saveRDS(delegatesdf,"delegatesdf.RDS")
#################################################################################
#################################################################################

