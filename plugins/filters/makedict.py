class FilterModule(object):
    def filters(self):
        return { 'makedict': lambda _list_of_dicts, _primary_key, _key_of_interest: { k[_primary_key]: k['tags'].get(_key_of_interest,None) for k in _list_of_dicts }  }
#return { 'makedict': lambda _list_of_dicts, _primary_key, _key_of_interest: "_primary_key={} type={} _key_of_interest={} type={} _list_of_dicts={} type={}".format(_primary_key, type(_primary_key), _key_of_interest, type(_key_of_interest), _list_of_dicts, type(_list_of_dicts)) }
       