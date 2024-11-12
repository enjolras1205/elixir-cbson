# elixir-cbson

[![Hex.pm Version](https://img.shields.io/hexpm/v/cbson.svg?style=flat)](https://hex.pm/packages/cbson)

BSON NIF for Elixir language http://bsonspec.org

## THANKS

This library has taken many great ideas and codes from [Jiffy](https://github.com/davisp/jiffy) to make it fasting and flexible.

The API of elixir-cbson is the same as [elixir-bson](https://github.com/checkiz/elixir-bson) which I always used in my projects.

## WARNING

* At this moment, elixir-cbson only supports Little-endian machine and I will improve it sometime.
* Only support Elixir 1.1.0+ 

## MongoDB Driver
The MongodB driver using this project is [here](https://github.com/ejoy/elixir-mongo/tree/cbson), 
being changed from [elixir-mongo](https://github.com/checkiz/elixir-mongo).


## Usage

### `CBson.decode/1,2`

* `CBson.decode(iodata)`
* `CBson.decode(iodata, options)`

The options for decode are:

* `:return_lists` - Return objects using the lists data(keywrods) type.
* `:return_atom` - Return objects using atom keys instead of string.
  The internal implementation is using String.to_existing_atom/1, if 
  convertion failed, the string key returned.
* `{:nil_term, term}` - Returns the specified `term` instead of `nil`
  when decoding BSON. This is for people that wish to use `undefined`
  instead of `nil`.
* `:use_null` - Returns the atom `null` instead of `nil` when decoding
  BSON. This is a short hand for `{nil_term, null}`.
* `:return_josn` - Returns objects converted `ObjectId`, `UTC`, `Bin`, `Regex` and
  `Timestamp` to suitable types for easier convert to json 
* `:return_trailer` - If any data is found after the first
  BSON term is decoded the return value of decode/2 becomes
  `{:has_trailer, first_term, rest_data::iodata()}`. This is useful to
  decode multiple terms in a single binary.
* `{:bytes_per_red, n}` where n >= 0 - This controls the number of
  bytes that elixir-cbson will process as an equivalent to a reduction. Each
  20 reductions we consume 1% of our allocated time slice for the current
  process. When the Erlang VM indicates we need to return from the NIF.


### `CBson.encode/1,2`

* `CBson.encode(bson_doc)`
* `CBson.encode(bson_doc, options)`

The options for encode are:

* `force_utf8` - Force strings to encode as UTF-8 by fixing broken
  surrogate pairs and/or using the replacement character to remove
  broken UTF-8 sequences in data.
* `{:nil_term, term}` - Returns the specified `term` instead of `nil`
  when decoding BSON. This is for people that wish to use `undefined`
  instead of `nil`.
* `:use_null` - Returns the atom `null` instead of `nil` when decoding
  BSON. This is a short hand for `{nil_term, null}`.
* `{:bytes_per_red, n}` - Refer to the decode options

## Types

BSON Type | Elixir Type       | Notes
----------|-------------------|-----------------------
ObjectId  | %Bson.ObjectId{}  | 
double    | double            |
string    | string            |
doc       | map or keywords   | :return_lists
array     | list              |
binary    | %Bson.Bin{}       |
bool      | atom: true/false  |
datetime  | %Bson.UTC{}       |
Null      | nil               | :use_null/:nil_term
Regex     | %Bson.Regex{}     |  
JavaScript|                   | not supported
int32     | integer           |
Timestamp | %Bson.Timestamp{} |
int64     | integer           |
Min key   | atom: min_key     |
Max key   | atom: max_key     |


## Benchmarking
There're some benchmark cases vs [mongodb](https://github.com/ericmj/mongodb) & [elixir-bson](https://github.com/checkiz/elixir-bson)
```
MIX_ENV=bench mix bench
```

