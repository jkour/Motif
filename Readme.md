# Motif
Motif is a flexible way to manage patterns that generate unique results in cases where there are many sub-cases with additional sub-cases. 

It lets you build simple decision trees without the need to create *if* statements. It makes the minimum number of comparisons necessary to generate a match.

 **The current version is v.2.0.0**: This version has introduced breaking changes

# Simple Example
Suppose you have the following mapping:
```
x:1      --> A
x:1, y:1 --> B
x:1, y:2 --> C
```
Then, motif gets the following results:
```
x:1      -> A
x:2      -> does not exist
x:1, y:1 -> B
x:1, y:2 -> C
x:2, y:2 -> does not exist
y:1      -> does not exist
```

# A More Useful Example
Suppose we want to get the tax rate per country. For example, in Ireland the VAT is 23%, in UK 20%, etc. Moreover, each country has different tax classes. For details see [here](<https://www.avalara.com/vatlive/en/vat-rates/european-vat-rates.html>).

We define the tax for each case by creating unique patterns:
```pascal
var
  taxFunc: TFunc<Double, Double>;
  motif: TMotif;

...
  
  motif:=TMotif.Create;
  taxFunc:=function (aRate: Double): Double
           begin
            // For illustration
            result:=aRate;
           end;

  motif.add<Double>('country: UK', function:double
                                   begin
                                     result:=taxFunc(0.19);
                                   end)
       .add<Double>('country: UK, type: food', function:double
                                   begin
                                     result:=taxFunc(0.00);
                                   end);
```
Finally, we retrieve the tax rate by, simply, calling this:
```pascal
var
  list:TList<TMotifItem>;
begin
  ...
  list:=motif.find('country: UK');
  writeln(list[0].Value.AsExtended.tostring);

  motif.clear;
  list:=motif.find('country: UK, type: food'');
  writeln(list[0].Value.AsExtended.tostring);
  
  list.Free <-- Very important; this needs to be descroyed manually (but not to be created)
end;
  
```

# Glob Matching
Motif understands [glob matching](<https://en.wikipedia.org/wiki/Glob_%28programming%29>). If the pattern is this:
```
b:1, x*y --> BC
```
Then, all the following calls will return ```BC```
```
b:1, xAy
b:1, xhy
...
```
The pattern works the other way around. A request to ```b:*``` will also return a list with ```BC``` and any additional patterns registered with the prefix ```b:```


# Customisation
You can change the way values are stored in Motif. After Motif adds a value to the internal collection, it fires the ```OnAdd``` event.

# Comparison with v.1.x.x
The ```Benchmark.Motif``` project generates **1,000,000** patterns and performs an addition, deletion, pattern finding ang glob finding

|Test      |  v.1.2.0           |  v.2.0.0         |
|----------|:------------------:|:----------------:|
|add       |12sec (254MB)       |5.8sec (458MB)    |
|remove    |1.21sec (240MB)     |445msec (320MB)   |
|find      |60sec (68.7MB)      |1.36sec (68.7MB)  |
|find glob |2min 30sec (68.7MB) |1min 3sec (68.7MB)|

# Inspiration
This project is inspired by [patrun](<https://www.npmjs.com/package/patrun>)

# License

This project is licensed under the [Apache 2.0 license](LICENSE).

## Contact
If you have spotted an error, have a suggestion, found any issues or a feature requests, please use the following channels. PRs are, also, welcome
- [github Issues](<https://github.com/jkour/motif/wiki>)
- [j_kour@hotmail.com](mailto:j_kour@hotmail.com)