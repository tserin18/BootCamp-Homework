# Part 1
import os
import csv

#Function to return vote count for respective candidate
def candidate_vote_count(li): 
    dct1 = {} 
    for item in li:
        dct1[item] = dct1.get(item,0) + 1
    return dct1 
def candidate_vote_percent(dct2):
    for k,v in dct2.items():
        #Round to two decimall digits
        percent_vote.append(round((v/total_vote_count)*100,2))
        vote_count.append(v)
        candidates.append(k)

#list to store vlaues
names=[]
percent_vote=[]
candidates=[]
vote_count= []

#dictionary to map names with vote count and calculate vote percent
dct = {} 
#Initialize vote count statring from zero
total_vote_count = 0
popular_vote_count=0
winner =""

# Grab budget_data_1 CSV
csvpath = os.path.join('raw_data' , 'election_data_2.csv')
#read csv    
with open(csvpath,  newline="") as csvFile:
    csvReader = csv.reader(csvFile, delimiter=',')

    # Skipp headers
    next(csvReader, None)
    #Loop through csv to get and total vote count and candidate names 
    for row in csvReader:
        names.append(row[2])
        total_vote_count +=1

    #Calculate vote count for each candidates 
    dct = candidate_vote_count(names)
    
    #Calculate vote percent for each candidate looping through dictionary
    candidate_vote_percent(dct)

    #Print final outcome
    print("Election Results")
    print("-------------------------")  
    print("Total Votes: "+ str(total_vote_count))  
    print("-------------------------")        
    for i in range(len(candidates)):  
        print(candidates[i]+ " : " + str(percent_vote[i])+"% " + "(" + str(vote_count[i]) +")")
        if (int(vote_count[i]) > popular_vote_count):
            popular_vote_count= int(vote_count[i])
            winner = candidates[i]

    print("-------------------------") 
    print("Winner: "+ winner) 
    print("-------------------------") 
    

