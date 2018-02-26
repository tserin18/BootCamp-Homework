# Part 1
import os
import csv

total_revenue = 0
old_revenue = 0
new_revenue = 0
total_change = 0
average_revenue=0
count = 0

# Grab budget_data_1 CSV
budget1 = os.path.join('raw_data' , 'budget_data_1.csv')
#read csv 
with open(budget1, 'r') as csvFile:
    csvReader = csv.reader(csvFile, delimiter=',')

    # Skipp headers
    next(csvReader, None)

    #Calculate total revenue    
    for row in csvReader:
       new_revenue = int(row[1])
       total_revenue = total_revenue + new_revenue
       change=new_revenue-old_revenue
       
       #Check if first month 
       if new_revenue==total_revenue:
           change =0
           greatest_revenue_increase = 0
           greatest_revenue_decrease = 0
       
       #Check greatest revenue increase
       elif change>greatest_revenue_increase:
           greatest_revenue_increase = change
           greatest_revenue_date = row[0]
       
       #Check greatest revenue decrease
       elif change <greatest_revenue_decrease:
           greatest_revenue_decrease = change
           least_revenue_date = row[0]
       
       #Calculate total change 
       total_change = total_change + change
       count = count + 1
       old_revenue=new_revenue
    
    #Calculate average revenue
    average_revenue=total_change/(count-1)
        
    #Print Final Outcome
    print("Financial Analysis")
    print("---------------------------- ")
    print("Total Months: " + str(count))
    print("Total Revenue: " + str(total_revenue))
    print("Average Revenue: " + str(average_revenue))
    print("Greatest Increase: " + str(greatest_revenue_increase) + " "+str(greatest_revenue_date))
    print("Greatest Increase: " + str(greatest_revenue_decrease) + " "+str(least_revenue_date))


