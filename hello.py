import time

# 44057
import MetaTrader5 as mt5

# Connect to MetaTrader 5
if not mt5.initialize():
    print("Failed to initialize MetaTrader5")
    mt5.shutdown()

# Login to your account
account = 4474105  # your MT5 account number
password = "your_password"  # your MT5 account password
server = "your_broker_server"  # your broker's server
if not mt5.login(account, password, server):
    print("Failed to login to MetaTrader5")
    mt5.shutdown()

# Define trading parameters
symbol = "EURUSD"
lot = 0.1
slippage = 5
magic_number = 123456

def get_signal():
    # Simplified strategy: Buy if close price is greater than open price
    # Sell if close price is less than open price
    rates = mt5.copy_rates_from_pos(symbol, mt5.TIMEFRAME_M1, 0, 1)
    if rates is None or len(rates) == 0:
        return None

    rate = rates[0]
    if rate['close'] > rate['open']:
        return "buy"
    elif rate['close'] < rate['open']:
        return "sell"
    else:
        return None

def place_order(order_type):
    # Define the order request
    request = {
        "action": mt5.TRADE_ACTION_DEAL,
        "symbol": symbol,
        "volume": lot,
        "type": mt5.ORDER_TYPE_BUY if order_type == "buy" else mt5.ORDER_TYPE_SELL,
        "price": mt5.symbol_info_tick(symbol).ask if order_type == "buy" else mt5.symbol_info_tick(symbol).bid,
        "slippage": slippage,
        "magic": magic_number,
        "comment": "Python script order",
        "type_time": mt5.ORDER_TIME_GTC,
        "type_filling": mt5.ORDER_FILLING_IOC,
    }

    # Send the order request
    result = mt5.order_send(request)
    return result

while True:
    signal = get_signal()
    if signal:
        result = place_order(signal)
        if result.retcode != mt5.TRADE_RETCODE_DONE:
            print("Order failed, retcode={}".format(result.retcode))
        else:
            print("Order placed successfully: {}".format(signal))
    time.sleep(60)  # Wait for 1 minute before checking again

# Shutdown MetaTrader 5 connection
mt5.shutdown()
