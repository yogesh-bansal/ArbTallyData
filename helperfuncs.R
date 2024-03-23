library("ghql")
library("jsonlite")

con <- GraphqlClient$new(
                          url = "https://api.tally.xyz/query",
                          headers = list("Api-Key" = "****************************************************************")
                        )

#################################################################################
#################################################################################
## Make Query
qry <- Query$new()
qry$query('delegatedata',
  'query Delegates($input: DelegatesInput!)
  {
    delegates(input: $input)
    {
      nodes
      {
        ... on Delegate
        {
          id
          account
          {
            address
            name
            ens
          }
          votesCount
          delegatorsCount
        }
      }
      pageInfo
      {
        firstCursor
        lastCursor
      }
    }
  }'
)

qry$query('proposaldata',
  'query Proposals($chainId: ChainID!, $governorIds: Address!) {
          proposals(chainId: $chainId, governors: [$governorIds]) {
            id
            title
            description
            block{
              timestamp
            }
            start{
                    ... on Block {timestamp}
            }
            end{
                    ... on Block {timestamp}
            }
            governanceId
            eta
            proposer{
              address
            }
        }
  }'
)

qry$query('votesdata',
  'query Proposals($chainId: ChainID!, $governorIds: Address!, $propId:ID!) {
          proposals(chainId: $chainId, governors: [$governorIds], proposalIds:[$propId]) {
            id
            votes {
                voter {
                    address
                }
                id
                support
                weight
                block{timestamp}
            }
        }
  }'
)
#################################################################################
#################################################################################