//+------------------------------------------------------------------+
//|                                                        Agent.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//--- parameters for writing data to file
input string    mql_to_python = "MqlPython.csv"
input string    python_to_mql = "PythonMql.csv";      // File name
input string    InpDirectoryName = "Data";     // Folder name
input string    symbol = "EURUSD";
input int       timeFrame = 5;

int handle;
//--- parameters for writing data to file
input string    tInpFileName = "BuyData.csv";      // File name
input string    tInpDirectoryName = "Data";

double stoplossVar = 10;
double lotSize = 1;

datetime time_array[];
double open_price[];
double close_price[];
double stochastics[];
double volume[];
double outcome[];
double bigMovingAvg[];
double smallMovingAvg[];

bool buy_signal_array[]; // signal array (true - buy, false - sell)
bool executeBuy = false;
int signal_index = 0;

ulong file_size;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

      //BUY
    if (OrdersTotal() == 0) { //Making sure only 1 order is open at a time

        execute_buy = RunBuyPrediction();
        Print("Execute Buy: ", execute_buy);

        if (execute_buy) {

            double minstoplevel = MarketInfo(0, MODE_STOPLEVEL);
            double risk = (minstoplevel + stoplossVar)*Point(); //Turning pips into point size i.e 2 pips = 0.0002 on price axis
            double reward = risk*8;

            //Rounding off SL and TP to charts required degree of accuracy
            double stoploss = NormalizeDouble(Bid - risk, Digits());
            double takeprofit = NormalizeDouble(Bid + reward, Digits());

            //Print("Current High:", High[0]," ","Ask:", Ask," ", "Buy:",Bid);
            //Print("Risk=",risk,"; ","Reward=",reward,"; ","SL=",stoploss,"; ","TP=",takeprofit, "; ","Lots=",lotSize);
            RefreshRates();
            int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stoploss, takeprofit,"My first order",0, 0, clrGreen);

            if(ticket < 0) {
                Alert("OrderSend failed with error #",GetLastError());
            } else {
                Print("OrderSend placed successfully");
            }

        }

      }
}

bool SendFeaturesToPython() {
    //time                 = iTime(NULL,PERIOD_M5,0);
    double open_price      = iOpen(NULL,PERIOD_M5,0);
    double close_price     = iClose(NULL,PERIOD_M5,0);
    double stochastics     = iStochastic(NULL,PERIOD_M5,5,3,3,MODE_SMA,0,MODE_MAIN,0);
    double volume          = iVolume(NULL,PERIOD_M5,0);

    int file_handle = FileOpen(InpDirectoryName+"//"+mql_to_python,FILE_CSV|FILE_WRITE,',');

    if (file_handle != INVALID_HANDLE) {

        PrintFormat("%s file is available for writing", mql_to_python);
        FileWrite(file_handle, index, open_price, close_price, stochastics, volume);
        FileClose(file_handle);
        PrintFormat("Data is written, %s file is closed", InpFileName);

    } else {
        PrintFormat("Failed to open %s file, Error code = %d", InpFileName, GetLastError());
    }

}

bool RunBuyPrediction() {

    bool execute_buy = false;
    string sep=",";                // A separator as a character
    ushort u_sep = StringGetCharacter(sep,0);                  // The code of the separator character
    string new_signal[];

    int file_handle = FileOpen(InpDirectoryName+"//"+PythonMql, FILE_CSV|FILE_READ,'@');

    if (file_handle != INVALID_HANDLE) {
        PrintFormat("%s file is available for reading", python_to_mql);
        //ulong file_size = FileSize(file_handle);
        string new_signal_from_py = FileReadString(file_handle);
        //--- Split the string to substrings
        StringSplit(new_signal_from_py, u_sep, new_signal);
        Print("RESULT: ", new_signal[0],"; ", new_signal[1]);

        if (new_signal[0] != signal_index) {
            if (new_signal[1] == 1) {
                execute_buy = true;
            } else {
                execute_buy = false;
            }
            signal_index = signal_index + 1;
        }
        //Print("Execute? ", execute_buy);
        FileClose(file_handle);
        PrintFormat("Data has been read, %s file is closed", python_to_mql);

        return execute_buy;
    } else {PrintFormat("Error, code = %d",GetLastError());};

    return execute_buy;

}
//+------------------------------------------------------------------+
