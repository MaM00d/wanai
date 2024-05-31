
# !pip3 install pandas

#|%%--%%| <F3sKrDEpmW|1z0xJ7GxbE>

import pandas as pd

#|%%--%%| <1z0xJ7GxbE|7seqg6WOzP>

with open('mssgg.txt', 'r',encoding="utf-8") as f:
   convs = f.read().split('\n\n')

# |%%--%%| <7seqg6WOzP|iRKhghIIYa>

z=0
lines=[]
for conv in convs:
    splits = conv.split('\n')
    for l in splits: 
        x=[]
        x.append(z)
        lin=[]
        lin = l.split(':')
        x.append(lin[0].strip())
        x.append(lin[1].strip())
        lines.append(x)
   
    z=z+1

# |%%--%%| <iRKhghIIYa|BbyoD39vKx>

df = pd.DataFrame(lines,columns=['convid','role','context'])

# |%%--%%| <BbyoD39vKx|MZn9USgjea>

final = []
history = ""

for rownum in df.index:
    currrow = df.loc[rownum]
    history = history+" ## " +currrow['role']+" : "+currrow['context']
    if rownum == 0:
              #first chat
        if currrow['role'] == "دكتور":
            
            final.append([history,"بداية",currrow['context']])
            
            

    elif rownum == (len(df.index)-1):
         #last Chat
        if currrow['role'] == "دكتور":
            final.append([history,currrow['context'],prevrow['context']])
        elif currrow['role'] == "مريض":
            final.append([history,currrow['context'],"اقفال"])
    else:
        prevrow =df.iloc[rownum-1]
        nextrow =df.iloc[rownum+1]
        if currrow['convid'] != prevrow['convid']:
            #first chat
         
            if currrow['role'] == "دكتور":
                final.append([history,"بداية",currrow['context']])
                # print("\n")
                # print("\n")
                # print(currrow['convid'])
                # print("\n")
                # print(prevrow['convid'])
                # print("\n")
                # print("\n")

        elif currrow['convid'] !=nextrow['convid']:
            #last Chat
            if currrow['role'] == "دكتور":
                final.append([history,currrow['context'],prevrow['context']])
            elif currrow['role'] == "مريض":
                final.append([history,currrow['context'],"اقفال"])
            history=""
        else:
            #normal chat between
            if currrow['role'] == "مريض":
                
                final.append([history,currrow['context'],prevrow['context']])
    

           
dff = pd.DataFrame(final,columns=['history','patient','doctor'])
    


# |%%--%%| <MZn9USgjea|v91AEQyWd6>

dff.to_csv('wannas_final.csv', index=False)

