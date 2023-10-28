/**
 * @file
 * Implements News meta strategy.
 */

// Prevents processing this includes file multiple times.
#ifndef STG_META_NEWS_MQH
#define STG_META_NEWS_MQH

// User input params.
INPUT2_GROUP("Meta News strategy: main params");
INPUT2 ENUM_STRATEGY Meta_News_Strategy_Main = STRAT_DEMARKER;        // Main strategy
INPUT2 ENUM_STRATEGY Meta_News_Strategy_Impact_High = STRAT_CHAIKIN;  // Strategy for high impact news
INPUT2 ENUM_STRATEGY Meta_News_Strategy_Impact_Medium = STRAT_NONE;   // Strategy for medium impact news
INPUT2 ENUM_STRATEGY Meta_News_Strategy_Impact_Low = STRAT_NONE;      // Strategy for low impact news
INPUT2 ENUM_STRATEGY Meta_News_Strategy_Impact_None = STRAT_NONE;     // Strategy for no impact news
INPUT3_GROUP("Meta News strategy: common params");
INPUT3 float Meta_News_LotSize = 0;                // Lot size
INPUT3 int Meta_News_SignalOpenMethod = 0;         // Signal open method
INPUT3 float Meta_News_SignalOpenLevel = 0;        // Signal open level
INPUT3 int Meta_News_SignalOpenFilterMethod = 32;  // Signal open filter method
INPUT3 int Meta_News_SignalOpenFilterTime = 3;     // Signal open filter time (0-31)
INPUT3 int Meta_News_SignalOpenBoostMethod = 0;    // Signal open boost method
INPUT3 int Meta_News_SignalCloseMethod = 0;        // Signal close method
INPUT3 int Meta_News_SignalCloseFilter = 32;       // Signal close filter (-127-127)
INPUT3 float Meta_News_SignalCloseLevel = 0;       // Signal close level
INPUT3 int Meta_News_PriceStopMethod = 1;          // Price limit method
INPUT3 float Meta_News_PriceStopLevel = 2;         // Price limit level
INPUT3 int Meta_News_TickFilterMethod = 32;        // Tick filter method (0-255)
INPUT3 float Meta_News_MaxSpread = 4.0;            // Max spread to trade (in pips)
INPUT3 short Meta_News_Shift = 0;                  // Shift
INPUT3 float Meta_News_OrderCloseLoss = 30;        // Order close loss
INPUT3 float Meta_News_OrderCloseProfit = 30;      // Order close profit
INPUT3 int Meta_News_OrderCloseTime = -10;         // Order close time in mins (>0) or bars (<0)

// Structs.

// Defines struct with default user strategy values.
struct Stg_Meta_News_Params_Defaults : StgParams {
  Stg_Meta_News_Params_Defaults()
      : StgParams(::Meta_News_SignalOpenMethod, ::Meta_News_SignalOpenFilterMethod, ::Meta_News_SignalOpenLevel,
                  ::Meta_News_SignalOpenBoostMethod, ::Meta_News_SignalCloseMethod, ::Meta_News_SignalCloseFilter,
                  ::Meta_News_SignalCloseLevel, ::Meta_News_PriceStopMethod, ::Meta_News_PriceStopLevel,
                  ::Meta_News_TickFilterMethod, ::Meta_News_MaxSpread, ::Meta_News_Shift) {
    Set(STRAT_PARAM_LS, ::Meta_News_LotSize);
    Set(STRAT_PARAM_OCL, ::Meta_News_OrderCloseLoss);
    Set(STRAT_PARAM_OCP, ::Meta_News_OrderCloseProfit);
    Set(STRAT_PARAM_OCT, ::Meta_News_OrderCloseTime);
    Set(STRAT_PARAM_SOFT, ::Meta_News_SignalOpenFilterTime);
  }
};

// Define the enumeration to store news impact level.
enum ENUM_META_NEWS_IMPACT_LEVEL {
  HIGH,
  MEDIUM,
  LOW,
  NONE,
};

// Define the structure to store news records.
struct MetaForexNewsRecord {
  datetime start;
  string name;
  ENUM_META_NEWS_IMPACT_LEVEL impact;
  string currency;
};

#ifndef __resource__
// Defines empty news data in no resource mode.
string MetaNewsData2022 = "";
#endif

class Stg_Meta_News : public Strategy {
 protected:
  DictStruct<long, DictStruct<short, MetaForexNewsRecord>> news;
  DictStruct<long, Ref<Strategy>> strats;

 public:
  Stg_Meta_News(StgParams &_sparams, TradeParams &_tparams, ChartParams &_cparams, string _name = "")
      : Strategy(_sparams, _tparams, _cparams, _name) {}

  static Stg_Meta_News *Init(ENUM_TIMEFRAMES _tf = NULL, EA *_ea = NULL) {
    // Initialize strategy initial values.
    Stg_Meta_News_Params_Defaults stg_meta_news_defaults;
    StgParams _stg_params(stg_meta_news_defaults);
    // Initialize Strategy instance.
    ChartParams _cparams(_tf, _Symbol);
    TradeParams _tparams;
    Strategy *_strat = new Stg_Meta_News(_stg_params, _tparams, _cparams, "(Meta) News");
    return _strat;
  }

  /**
   * Event on strategy's init.
   */
  void OnInit() {
    // Initialize strategies.
    StrategyAdd(Meta_News_Strategy_Main, 0);
    StrategyAdd(Meta_News_Strategy_Impact_High, 1);
    StrategyAdd(Meta_News_Strategy_Impact_Medium, 2);
    StrategyAdd(Meta_News_Strategy_Impact_Low, 3);
    StrategyAdd(Meta_News_Strategy_Impact_None, 4);
    // Initialize news.
    LoadNews();
  }

  /**
   * Load news records.
   */
  void LoadNews() {
    string news_records[];
    StringSplit(MetaNewsData2022, '\n', news_records);
    for (int i = 1; i < ArraySize(news_records); i++) {
      string record_fields[];
      DictStruct<short, MetaForexNewsRecord> record_dict;
      MetaForexNewsRecord record;
      StringSplit(news_records[i], ',', record_fields);
      if (ArraySize(record_fields) == 0) {
        // Ignore empty lines;
        continue;
      }
      record.start = StrToTime(record_fields[0]);
      record.name = record_fields[1];
      record.impact = (ENUM_META_NEWS_IMPACT_LEVEL)StringToInteger(record_fields[2]);
      record.currency = record_fields[3];
      if (news.KeyExists(record.start)) {
        record_dict = news.GetByKey(record.start);
      }
      record_dict.Push(record);
      news.Set(record.start, record_dict);
    }
  }

  /**
   * Sets strategy.
   */
  bool StrategyAdd(ENUM_STRATEGY _sid, long _index = -1) {
    ENUM_TIMEFRAMES _tf = Get<ENUM_TIMEFRAMES>(STRAT_PARAM_TF);
    Ref<Strategy> _strat = StrategiesManager::StrategyInitByEnum(_sid, _tf);
    if (!_strat.IsSet()) {
      _strat = StrategiesMetaManager::StrategyInitByEnum((ENUM_STRATEGY_META)_sid, _tf);
    }
    if (_strat.IsSet()) {
      _strat.Ptr().Set<long>(STRAT_PARAM_ID, Get<long>(STRAT_PARAM_ID));
      _strat.Ptr().Set<ENUM_TIMEFRAMES>(STRAT_PARAM_TF, _tf);
      _strat.Ptr().Set<int>(STRAT_PARAM_TYPE, _sid);
      _strat.Ptr().OnInit();
      if (_index >= 0) {
        strats.Set(_index, _strat);
      } else {
        strats.Push(_strat);
      }
    }
    return _strat.IsSet();
  }

  /**
   * Gets strategy.
   */
  Ref<Strategy> GetStrategy(ENUM_ORDER_TYPE _cmd, int _method = 0, float _level = 0.0f, int _shift = 0) {
    Ref<Strategy> _strat_ref = strats.GetByKey(0);
    datetime _current_dt = (datetime)round((double)(TimeCurrent() / 60)) * 60;  // Round timestamp to a minute.
    if (news.KeyExists(_current_dt)) {
      DictStruct<short, MetaForexNewsRecord> _news_records = news.GetByKey(_current_dt);
      for (DictStructIterator<short, MetaForexNewsRecord> iter = _news_records.Begin(); iter.IsValid(); ++iter) {
        MetaForexNewsRecord _news_item = iter.Value();
        switch (_news_item.impact) {
          case HIGH:
            _strat_ref = strats.GetByKey(1);
            return _strat_ref;
            break;
          case MEDIUM:
            _strat_ref = strats.GetByKey(2);
            break;
          case LOW:
            _strat_ref = strats.GetByKey(3);
            break;
          case NONE:
            _strat_ref = strats.GetByKey(4);
            break;
        }
      }
    }
    return _strat_ref;
  }

  /**
   * Gets price stop value.
   */
  float PriceStop(ENUM_ORDER_TYPE _cmd, ENUM_ORDER_TYPE_VALUE _mode, int _method = 0, float _level = 0.0f,
                  short _bars = 4) {
    float _result = 0;
    uint _ishift = 0;  // @fixme
    if (_method == 0) {
      // Ignores calculation when method is 0.
      return (float)_result;
    }
    Ref<Strategy> _strat_ref = GetStrategy(_cmd, _method, _level, _ishift);  // @todo: Add shift.
    if (!_strat_ref.IsSet()) {
      // Returns false when strategy is not set.
      return false;
    }

    _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
    _method = _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM);
    //_shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
    _result = _strat_ref.Ptr().PriceStop(_cmd, _mode, _method, _level /*, _shift*/);
    return (float)_result;
  }

  /**
   * Check strategy's opening signal.
   */
  bool SignalOpen(ENUM_ORDER_TYPE _cmd, int _method, float _level = 0.0f, int _shift = 0) {
    bool _result = true;
    MarketTimeForex _mtf;
    Ref<Strategy> _strat_ref = GetStrategy(_cmd, _method, _level, _shift);
    if (_strat_ref.IsSet()) {
      _level = _level == 0.0f ? _strat_ref.Ptr().Get<float>(STRAT_PARAM_SOL) : _level;
      _method = _method == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SOM) : _method;
      _shift = _shift == 0 ? _strat_ref.Ptr().Get<int>(STRAT_PARAM_SHIFT) : _shift;
      _result &= _strat_ref.Ptr().SignalOpen(_cmd, _method, _level, _shift);
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

#endif  // STG_META_NEWS_MQH
