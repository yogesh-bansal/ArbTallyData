library(lubridate)
source("helperfuncs.R")

#################################################################################
## Scrape Proposals under Both governance accounts Core & Treasury
#################################################################################
variables <- list(
                    "chainId"="eip155:42161",
                    "governorIds" = "0xf07DeD9dC292157749B6Fd268E37DF6EA38395B9"
              )

resp <- con$exec(qry$queries$proposaldata,variables=variables)
resp <- fromJSON(resp)$data$proposals
resp$block <- resp$block$timestamp
resp$start <- resp$start$timestamp
resp$end <- resp$end$timestamp
resp$proposer <- resp$proposer$address
variables2 <- list(
                    "chainId"="eip155:42161",
                    "governorIds" = "0x789fC99093B09aD01C34DC7251D0C89ce743e5a4"
              )
resp2 <- con$exec(qry$queries$proposaldata,variables=variables2)
resp2 <- fromJSON(resp2)$data$proposals
resp2$block <- resp2$block$timestamp
resp2$start <- resp2$start$timestamp
resp2$end <- resp2$end$timestamp
resp2$proposer <- resp2$proposer$address
respp <- rbind(resp,resp2)
respp <- respp[order(as_datetime(respp$block)),]
#################################################################################
#################################################################################


#################################################################################
## Scrape Votes for each proposal
#################################################################################
votesdf <- data.frame()
for(idx in 1:nrow(respp))
{
    variablest <- list(
                        "chainId"="eip155:42161",
                        "governorIds" = strsplit(respp$governanceId[idx],":")[[1]][3],
                        "propId" = respp$id[idx]
                  )
    respt <- con$exec(qry$queries$votesdata,variables=variablest)
    respt <- cbind(id=respp$id[idx],fromJSON(respt)$data$proposals$votes[[1]])
    respt$voter <- respt$voter$address
    respt$block <- respt$block$timestamp
    votesdf <- rbind(votesdf,respt)
    message(nrow(votesdf))
}


saveRDS(respp,"Proposals.RDS")
# readr::write_csv(respp,"Proposals.csv")
saveRDS(votesdf,"Votes.RDS")
# readr::write_csv(votesdf,"Votes.csv")
#################################################################################
#################################################################################
