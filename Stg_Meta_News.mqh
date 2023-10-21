/**
 * @file
 * Implements Timezone meta strategy.
 */

// Prevents processing this includes file multiple times.
#ifndef STG_META_TIMEZONE_MQH
#define STG_META_TIMEZONE_MQH

// User input params.
INPUT2_GROUP("Meta Timezone strategy: main params");
INPUT2 ENUM_STRATEGY Meta_Timezone_Strategy_London = STRAT_DEMARKER;   // London market hours strategy
INPUT2 ENUM_STRATEGY Meta_Timezone_Strategy_NewYork = STRAT_ICHIMOKU;  // New York market hours strategy
INPUT2 ENUM_STRATEGY Meta_Timezone_Strategy_Sydney = STRAT_BANDS;      // Sydney market hours strategy
INPUT2 ENUM_STRATEGY Meta_Timezone_Strategy_Tokyo = STRAT_ENVELOPES;   // Tokyo market hours strategy
INPUT2_GROUP("Meta Timezone strategy: common params");
INPUT2 float Meta_Timezone_LotSize = 0;                // Lot size
INPUT2 int Meta_Timezone_SignalOpenMethod = 0;         // Signal open method
INPUT2 float Meta_Timezone_SignalOpenLevel = 0;        // Signal open level
INPUT2 int Meta_Timezone_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT2 int Meta_Timezone_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT2 int Meta_Timezone_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT2 int Meta_Timezone_SignalCloseMethod = 0;        // Signal close method
INPUT2 int Meta_Timezone_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT2 float Meta_Timezone_SignalCloseLevel = 0;       // Signal close level
INPUT2 int Meta_Timezone_PriceStopMethod = 0;          // Price limit method
INPUT2 float Meta_Timezone_PriceStopLevel = 2;         // Price limit level
INPUT2 int Meta_Timezone_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT2 float Meta_Timezone_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT2 short Meta_Timezone_Shift = 0;                  // Shift
INPUT2 float Meta_Timezone_OrderCloseLoss = 30;        // Order close loss
INPUT2 float Meta_Timezone_OrderCloseProfit = 30;      // Order close profit
INPUT2 int Meta_Timezone_OrderCloseTime = -10;         // Order close time in mins (>0) or bars (<0)

// Structs.

// Defines struct with default user strategy values.
struct Stg_Meta_Timezone_Params_Defaults : StgParams {
  Stg_Meta_Timezone_Params_Defaults()
      : StgParams(::Meta_Timezone_SignalOpenMethod, ::Meta_Timezone_SignalOpenFilterMethod,
                  ::Meta_Timezone_SignalOpenLevel, ::Meta_Timezone_SignalOpenBoostMethod,
                  ::Meta_Timezone_SignalCloseMethod, ::Meta_Timezone_SignalCloseFilter,
                  ::Meta_Timezone_SignalCloseLevel, ::Meta_Timezone_PriceStopMethod, ::Meta_Timezone_PriceStopLevel,
                  ::Meta_Timezone_TickFilterMethod, ::Meta_Timezone_MaxSpread, ::Meta_Timezone_Shift) {
    Set(STRAT_PARAM_LS, ::Meta_Timezone_LotSize);
    Set(STRAT_PARAM_OCL, ::Meta_Timezone_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, ::Meta_Timezone_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, ::Meta_Timezone_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, ::Meta_Timezone_SignalOpenFilterTime);
  }
};

class Stg_Meta_Timezone : public Strategy {
 protected:
  DictStruct<long, Ref<Strategy>> strats;

 public:
  Stg_Meta_Timezone(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Meta_Timezone *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Meta_Timezone_Params_Defaults stg_timezone_defaults;
    StgParams _stg_params(stg_timezone_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Meta_Timezone(_stg_params, _tparams, _cparams, "(Meta) Timezone");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    StrategyAdd(Meta_Timezone_Strategy_London, STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_LONDON));
    StrategyAdd(Meta_Timezone_Strategy_NewYork, STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_NEWYORK));
    StrategyAdd(Meta_Timezone_Strategy_Sydney, STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_SYDNEY));
    StrategyAdd(Meta_Timezone_Strategy_Tokyo, STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_TOKYO));
  }

  /**
   * Sets strategy.
   */
  bool StrategyAdd(ENUM_STRATEGY _sid, long _index) {
    bool _result = true;
    long _magic_no = Get<long>(STRAT_PARAM_ID);
    ENUM_TIMEFRAMES _tf = Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF);

    switch (_sid) {
      case STRAT_NONE:
        break;
      case STRAT_AC:
        _result &= StrategyAdd<Stg_AC>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_AD:
        _result &= StrategyAdd<Stg_AD>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ADX:
        _result &= StrategyAdd<Stg_ADX>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_AMA:
        _result &= StrategyAdd<Stg_AMA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ARROWS:
        _result &= StrategyAdd<Stg_Arrows>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ASI:
        _result &= StrategyAdd<Stg_ASI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ATR:
        _result &= StrategyAdd<Stg_ATR>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ALLIGATOR:
        _result &= StrategyAdd<Stg_Alligator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_AWESOME:
        _result &= StrategyAdd<Stg_Awesome>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BWMFI:
        _result &= StrategyAdd<Stg_BWMFI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BANDS:
        _result &= StrategyAdd<Stg_Bands>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BEARS_POWER:
        _result &= StrategyAdd<Stg_BearsPower>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_BULLS_POWER:
        _result &= StrategyAdd<Stg_BullsPower>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_CCI:
        _result &= StrategyAdd<Stg_CCI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_CHAIKIN:
        _result &= StrategyAdd<Stg_Chaikin>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_DEMA:
        _result &= StrategyAdd<Stg_DEMA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_DPO:
        _result &= StrategyAdd<Stg_DPO>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_DEMARKER:
        _result &= StrategyAdd<Stg_DeMarker>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ENVELOPES:
        _result &= StrategyAdd<Stg_Envelopes>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_FORCE:
        _result &= StrategyAdd<Stg_Force>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_FRACTALS:
        _result &= StrategyAdd<Stg_Fractals>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_GATOR:
        _result &= StrategyAdd<Stg_Gator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_HEIKEN_ASHI:
        _result &= StrategyAdd<Stg_HeikenAshi>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ICHIMOKU:
        _result &= StrategyAdd<Stg_Ichimoku>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_INDICATOR:
        _result &= StrategyAdd<Stg_Indicator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA:
        _result &= StrategyAdd<Stg_MA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_BREAKOUT:
        _result &= StrategyAdd<Stg_MA_Breakout>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_CROSS_PIVOT:
        _result &= StrategyAdd<Stg_MA_Cross_Pivot>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_CROSS_SHIFT:
        _result &= StrategyAdd<Stg_MA_Cross_Shift>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_CROSS_SUP_RES:
        _result &= StrategyAdd<Stg_MA_Cross_Sup_Res>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MA_TREND:
        _result &= StrategyAdd<Stg_MA_Trend>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MACD:
        _result &= StrategyAdd<Stg_MACD>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MFI:
        _result &= StrategyAdd<Stg_MFI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_MOMENTUM:
        _result &= StrategyAdd<Stg_Momentum>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OBV:
        _result &= StrategyAdd<Stg_OBV>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR:
        _result &= StrategyAdd<Stg_Oscillator>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_DIVERGENCE:
        _result &= StrategyAdd<Stg_Oscillator_Divergence>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_MULTI:
        _result &= StrategyAdd<Stg_Oscillator_Multi>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_CROSS:
        _result &= StrategyAdd<Stg_Oscillator_Cross>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_CROSS_SHIFT:
        _result &= StrategyAdd<Stg_Oscillator_Cross_Shift>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_CROSS_ZERO:
        _result &= StrategyAdd<Stg_Oscillator_Cross_Zero>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_RANGE:
        _result &= StrategyAdd<Stg_Oscillator_Range>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSCILLATOR_TREND:
        _result &= StrategyAdd<Stg_Oscillator_Trend>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_OSMA:
        _result &= StrategyAdd<Stg_OsMA>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_PATTERN:
        _result &= StrategyAdd<Stg_Pattern>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_PINBAR:
        _result &= StrategyAdd<Stg_Pinbar>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_PIVOT:
        _result &= StrategyAdd<Stg_Pivot>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_RSI:
        _result &= StrategyAdd<Stg_RSI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_RVI:
        _result &= StrategyAdd<Stg_RVI>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_SAR:
        _result &= StrategyAdd<Stg_SAR>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_STDDEV:
        _result &= StrategyAdd<Stg_StdDev>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_STOCHASTIC:
        _result &= StrategyAdd<Stg_Stochastic>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_WPR:
        _result &= StrategyAdd<Stg_WPR>(_tf, _magic_no, _sid, _index);
        break;
      case STRAT_ZIGZAG:
        _result &= StrategyAdd<Stg_ZigZag>(_tf, _magic_no, _sid, _index);
        break;
      default:
        logger.Warning(StringFormat("Unknown strategy: %d", _sid), __FUNCTION_LINE__, GetName());
        break;
    }

    return _result;
  }

  /**
   * Adds strategy to specific timeframe.
   *
   * @param
   *   _tf - timeframe to add the strategy.
   *   _magic_no - unique order identified
   *
   * @return
   *   Returns true if the strategy has been initialized correctly, otherwise false.
   */
  template <typename SClass>
  bool StrategyAdd(ENUM_TIMEFRAMES _tf, long _magic_no = 0, int _type = 0, long _index = 0) {
    bool _result = true;
    _magic_no = _magic_no > 0 ? _magic_no : rand();
    Ref<Strategy> _strat = ((SClass *)NULL).Init(_tf);
    _strat.Ptr().Set<long>(STRAT_PARAM_ID, _magic_no);
    _strat.Ptr().Set<ENUM_TIMEFRAMES>(STRAT_PARAM_TF, _tf);
    _strat.Ptr().Set<int>(STRAT_PARAM_TYPE, _type);
    _strat.Ptr().OnInit();
    strats.Set(_index, _strat);
    return _result;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    bool _result = false;  // strats.Size() > 0;
    MarketTimeForex _mtf;
    Ref<Strategy> _strat_ref;
    _strat_ref = strats.GetByKey(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_LONDON));
    if (_strat_ref.IsSet() && _mtf.CheckHours(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_LONDON))) {
      _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
      _method = _method == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM) : _method;
      _shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
      _result |= _strat_ref.Ptr().SignalOpen(_cmd, _method, _level, _shift);
    }
    _strat_ref = strats.GetByKey(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_NEWYORK));
    if (_strat_ref.IsSet() && _mtf.CheckHours(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_NEWYORK))) {
      _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
      _method = _method == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM) : _method;
      _shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
      _result |= _strat_ref.Ptr().SignalOpen(_cmd, _method, _level, _shift);
    }
    _strat_ref = strats.GetByKey(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_SYDNEY));
    if (_strat_ref.IsSet() && _mtf.CheckHours(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_SYDNEY))) {
      _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
      _method = _method == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM) : _method;
      _shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
      _result |= _strat_ref.Ptr().SignalOpen(_cmd, _method, _level, _shift);
    }
    _strat_ref = strats.GetByKey(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_TOKYO));
    if (_strat_ref.IsSet() && _mtf.CheckHours(STRUCT_ENUM(MarketTimeForex, MARKET_TIME_FOREX_HOURS_TOKYO))) {
      _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
      _method = _method == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM) : _method;
      _shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
      _result |= _strat_ref.Ptr().SignalOpen(_cmd, _method, _level, _shift);
    }
    return _result;
  }

  /**
   * Check strategy's closing signal.
   */
  bool SignalClose(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    bool _result = false;
    _result = SignalOpen(Order::NegateOrderType(_cmd), _method, _level, _shift);
    return _result;
  }
};

#endif  // STG_META_TIMEZONE_MQH
