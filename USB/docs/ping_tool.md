# Ping Tool
[Ping Tool Script](../Scripts/ping_tool/ping_stats.ps1)


## Description
The Program is written in Powershell, it is also available as a standalone executable or as a python script.

The Ping tool ist a tool to capture the data from multiple ping sessions. The data is stored in a json file that is saved in the downloads' folder.  
The Data can be displayed in the program itself or as a graph using the [Ping Tool API](https://api.heggli.dev/ping-graph) from the API HUB.

## Usage

### Requirements
- Powershell 5.1 or higher
- Windows 10 or higher
- Internet connection (Graph generation)
- ``Set-ExecutionPolicy RemoteSigned`` **(run as admin)**   
  - This is required to run the script, it can be reverted after the script has been executed. 
  - Without this, it will only be able to run scripts by copying and pasting the source code into a powershell terminal.

### step 1
The Powershell script can be executed by running the `ping_tool.ps1` file
or by copy and pasting the source code into a powershell terminal.

### step 2
Select what you want to do by entering the corresponding letter and pressing enter.
Default is `p` for ping.
```
What would you like to do?
  l - load ping results from file
  p - ping device
  g - generate graph
>> :
```

jump to  
[l](#l1)  
[p](#p1)  
[g](#g1)

### <a id="p1"></a>step p.1
Enter the IP address or hostname of the device you want to ping.
Default is `google.com` (can be specified in the script)

### step p.2
Enter how long you want to ping the device in the following formats:
- `10` for 10 seconds
- `10s` for 10 seconds
- `10m` for 10 minutes

### step p.3
Wait for the ping to finish.  
![ping](assets/ping_tool.jpg)
The data will automatically be displayed after it finishes, jump to explanation for a more [detailed explanation](#l2)  

If you want to scann again press enter, otherwise enter `n` and press enter to save the data and close the script.


### <a id="l1"></a>step l.1
After you pressed enter an explorer select window will open for you to select a json file that was generated by the powershell, python or executable version.

![ping_tool_load_file.jpg](assets/ping_tool_load_file.jpg)

### <a id="l2"></a>step l.2
The Loaded/ping data is split into 3 parts.

At the end, you have the option of creating a graphic if you enter g and press enter.
For a more detailed description of how to create a graphic, [click here](#g1).


**<a id="datapoints"></a><span style="color:green">GREEN</span>**  
In the green Part there are all ping sessions listed horizontally with every ping and there latency.
Left of the latency is bar with a length between 1 and 6  
- <span style="color:Red">0</span> Means the target has not responded  
- <span style="color:green">#</span> Means the target responded under 10 ms  
- <span style="color:green">##</span> Means the target responded under 25 ms  
- <span style="color:yellow">###</span> Means the target responded under 40 ms  
- <span style="color:yellow">####</span> Means the target responded under 60 ms  
- <span style="color:red">#####</span> Means the target responded under 120 ms  
- <span style="color:red">######</span> Means the target responded took mor then 120 ms

**<span style="color:red">RED</span>**  
I this section all ping sessions are listed vertically where 1000 ms is represented by 1 symbol.
This means that if an answer has a duration of **2365 ms**, there are 2 symbols for it.
If there is no answer, it is represented by <span style="color:red">0000</span>  .
The colours are assigned the same as in the previous graphic.


**<span style="color:blue">BLUE</span>**  
The summarised data of the various ping sessions are displayed vertically here.

**<span style="color:yellow">YELLOW</span>**  
General information is displayed here.
- Start time of the first ping session
- End time of the last ping session
- Time from start of session 1 to end of last session
- Ping target
- The time of a single session in seconds

![loaded_data.jpg](assets/loaded_data.jpg)

### <a id="g1"></a>step g.1
A web page should now open, that looks like this.

Fist select you settings by selecting the Checkboxes, an explanation about what it does it provided by overing over it.  
After that, select a json file that was generated by the powershell, python or executable version.
The website will automatically go on when a file is selected.

[//]: # (```)

[//]: # (###################################################################################)

[//]: # (# When you are navigating throu the website by using the arrows from the browser  #)

[//]: # (# you have to relode the page otherwise it will not work.                         #)

[//]: # (###################################################################################)

[//]: # (```)
![graph_api.jpg](assets/graph_api.jpg)

### <a id="g1"></a>step g.2
If you select all settings, it will look something like this.  
- Option 1 (Show Times): displays the time in ms beside the datapoint.
- Option 2 (Show Table): displays the table at the bottom.  

The file can normally downloaded by right-clicking and click save as.

**GRAPH**  
At the top we see all Ping seasons with their chronicle order.
The data points will have a color corresponding to their values defined [here](#datapoints).   
if there was no respond there will be an `X` instead of a dot.

**TABLE**  
The Table will display pretty much be the same as the [Blue and Yellow Part](#l2) of the loading function.

![ping_graph.jpg](assets/ping_graph.jpg)








