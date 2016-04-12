library(acs) #querying ACS data
library(tigris) #gettng census geography spatial data
library(dplyr) #handling data

# load shapefiles 
library(tigris)
pumaGeo <- pumas("NY")
head(pumaGeo@data)

#apiKey <- "
#api.key.install(apiKey)
#Parameters for ACS queries: geography, table, end year, span

# PUMA 

## PUMA: northern Manhattan
nMnPUMA <- geo.make(state="NY", puma=c("3801", "3802", "3803", "3804"))

## PUMA: Bronx
bxPUMA <- geo.make(state="NY", puma=c("3701","3702","3703", "3704", "3705", "3706", "3707",
                                      "3708", "3709", "3710"))
    
## PUMA: Manhattan
mnPUMA <- geo.make(state="NY", puma=c("3801","3802","3803", "3804", "3805", "3806", "3807",
                                      "3808", "3809", "3810"))
# Census tracts

## Census tracts: Bronx
bxTracts <- geo.make(state="NY", county="Bronx", tract="*")

## Census tracts: Manhattan
mnTracts <- geo.make(state="NY", county="New York", tract="*")

## Census tracts: northern Manahttan
nMnTracts <- geo.make(state="NY", county="New York", tract=c('015602', '015802', '016002', '016200',
                                                             '016400', '016600', '016800', '017000', 
                                                              '017200', '017401', '017402', '017800', 
                                                              '018000', '018200', '018400', '018600', 
                                                              '018800', '019000', '019200', '019300', 
                                                              '019400', '019500', '019600', '019701', 
                                                              '019702', '019800', '019900', '020000', 
                                                              '020101', '020102', '020300', '020500', 
                                                              '020600', '020701', '020800', '020901', 
                                                              '021000', '021100', '021200', '021303', 
                                                              '021400', '021500', '021600', '021703', 
                                                              '021800', '021900', '022000', '022102', 
                                                              '022200', '022301', '022302', '022400', 
                                                              '022500', '022600', '022700', '022800', 
                                                              '022900', '023000', '023100', '023200', 
                                                              '023300', '023400', '023501', '023502', 
                                                              '023600', '023700', '023900', '024000', 
                                                              '024100', '024200', '024301', '024302', 
                                                              '024500', '024700', '024900', '025100', 
                                                              '025300', '025500', '025700', '025900', 
                                                              '026100', '026300', '026500', '026700', 
                                                              '026900', '027100', '027300', '027500', 
                                                              '027700', '027900', '028100', '028300', 
                                                              '028500', '028700', '029100', '029300', 
                                                              '029500', '029700', '029900', '030300', 
                                                              '030700', '030900', '031100'))


(testPUMA <- acs.fetch(2014, span=5, mnPUMA, table.name="Sex by Age", dataset="acs"))
(testTract <- acs.fetch(2014, span=5, nMnTracts, table.number="B01001", dataset="acs"))

# <<- assign object to workspace
pumaVar <- function(endyear, span, geo, var) {
    geoVar <- acs.fetch(endyear, span, geo, table.number=var,
                        col.names="pretty", dataset="acs")
    dfVar <<- data.frame(paste0(geoVar@geography$state,
                               geoVar@geography$publicusemicrodata),
                        geoVar@estimate, stringsAsFactors=F)
    rownames(dfVar) <- 1:nrow(dfVar)
    names(dfVar) <- c("GEOID", names(dfVar[2:length(dfVar)]))
    print(dfVar)
}

pumaVar(2014, 5, nMnPUMA, "B01001")

#(pumaAge <- acs.fetch(2014, span=5, nMnPUMA, table.number="B01001", 
#                      col.names="pretty", dataset="acs"))
#dfAge <- data.frame(paste0(pumaAge@geography$state, 
#                           pumaAge@geography$publicusemicrodataarea),
#                    pumaAge@estimate, stringsAsFactors=F)
#rownames(dfAge) <- 1:nrow(dfAge)

names(dfAge) <- c("GEOID", "total", "male", "mUnder5", "m5to9", "m10to14", "m15to17", 
                  "m18and19", "m20", "m21", "m22to24", "m25to29", "m30to34", "m35to39",
                  "m40to44", "m45to49", "m50to54", "m55to59", "m60and61", "m62to64",
                  "m65and66", "m67to69", "m70to74", "m75to79", "m80to84", "m85Over",
                  "female", "fUnder5", "f5to9", "f10to14", "f15to17", "f18and19", 
                  "f20", "f21", "f22to24", "f25to29", "f30to34", "f35to39", "f40to44",
                  "f45to49", "f50to54", "f55to59", "f60and61","f62to64", "f65and66", 
                  "f67to69", "f70to74", "f75to79", "f80to84", "f85Over")

dfAge$t60Over <- with(dfAge, rowSums(dfAge[,c(19:26, 43:50)])); head(dfAge)
dfAge$p60Over <- with(dfAge, t60Over/total)


names(dfCitizen) <- c("GEOID", "total", "bornUS", "bornPRIslandAreas", "bornAbroad",
                      "naturalization", "notCitizen")



