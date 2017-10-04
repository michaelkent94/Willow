# Willow Language Reference

## About the Language Reference
This document describes the grammar of the Willow language. Its goal is to give a formal definition and to provide a better understanding of the syntactical structure of the language.

### How to Read the Grammar
When possible, this reference tries to use EBNF notation to define the grammar. However, there are a few exceptions:

- Grammar productions are written with an arrow (→).
- Categories are written with *italic* text.
- Literal symbols are written with <tt>**bold fixed width**</tt> text. These can only appear on the right-hand side of a production rule.
- When multiple productions are possible for a given rule, these are separated by a pipe character (|).
- Oftentimes, plain text will be used in production rules where it makes sense. You'll have to use intuition in understanding these parts.

## Terminals
The terminals in Willow are the basic building blocks of production rules. Each terminal forms a valid token that is used to build higher categories. The terminals are generally written by a sequence of characters/symbols or a regular expression.

### Whitespace and Comments
Whitespace is generally ignored but can serve a few purposes that will be discussed later when they become relevant. The characters that are considered whitespace are: space (' '), horizontal tab ('\t'), carriage return ('\r'), and line feed ('\n').

Comments are effectively whitespace in the language. Willow only supports single line comments. They begin with <tt>**//**</tt> and end with a new line.

> ##### Grammar of Whitespace and Comments
>
> *whitespace* → *whitespace-item* *whitespace* | *whitespace-item*  
> *whitespace-item* → *newline* | *comment* | space | horizontal tab
>
> *newline* → carriage return | line feed | carriage return followed by line feed  
> *comment* → <tt>**//**</tt> (^*newline*)* *newline*

### Identifiers
In Willow, identifiers consist of upper and lowercase letters, i.e. a-z and A-Z.

> ##### Grammar of an Identifier
>
> *identifier* → *identifier-character*+  
> *identifier-character* → <tt>**a**</tt> through <tt>**z**</tt> or <tt>**A**</tt> through <tt>**Z**</tt>  

### Keywords and Punctuation
In general, Willow tries to stay away from reserving keywords. The idea is to keep the syntax of the language away from the semantics. However, there are some things that make sense to be defined as keywords.

- The boolean literals, <tt>**true**</tt> and <tt>**false**</tt>

Some symbols are reserved as punctuation and cannot be used to define custom [operators](#operators). These are: <tt>**(**</tt>, <tt>**)**</tt>, <tt>**{**</tt>, <tt>**}**</tt>, <tt>**[**</tt>, <tt>**]**</tt>, <tt>**.**</tt>, <tt>**,**</tt>, <tt>**:**</tt>, <tt>**;**</tt>, <tt>**@**</tt>, <tt>**#**</tt>, and <tt>**?**</tt>. The symbols <tt>**=**</tt>, <tt>**->**</tt>, and <tt>**<-**</tt> can be combined with other symbols but are reserved on their own.

### Literals
Literals represent a hard-coded value.

Here are a few examples:
```willow
13		   // Integer literal
2.71828		   // Floating point literal
"Hello, Willow!"   // String literal
false		   // Boolean literal
```

In Willow, literals have types. In the example above, the types are `Int`, `Float`, `String`, and `Bool` respectively.

#### Integer Literals
Integer literals are assumed to be written in decimal by default. To write an integer literal in hexadecimal instead, prepend the prefix <tt>**0x**</tt>.

Literals in decimal can contain the digits <tt>**0**</tt> through <tt>**9**</tt> and hexadecimal literals can contain the digits <tt>**0**</tt> through <tt>**9**</tt> and the characters <tt>**A**</tt> through <tt>**F**</tt> in either upper or lowercase.

Prepending a <tt>**-**</tt> to an integer literal makes it negative.

Willow allows the use of underscores (<tt>**_**</tt>) in integer literals to improve readability, but they are ignored by the compiler and don't affect the value. Likewise, leading zeros (<tt>**0**</tt>) are also ignored.

> ##### Grammar of Integer Literals
>
> *integer-literal* → *positive-integer-literal* | *negative-integer-literal*  
> *positive-integer-literal* → *decimal-literal* | *hexadecimal-literal*  
> *negative-integer-literal* → <tt>**-**</tt>*positive-integer-literal*  
>
> *decimal-literal* → (*decimal-digit* | <tt>**_**</tt>)+  
> *hexadecimal-literal* → <tt>**0x**</tt> (*hexadecimal-digit* | <tt>**_**</tt>)+  
>
> *decimal-digit* → <tt>**0**</tt> through <tt>**9**</tt>  
> *hexadecimal-digit* → <tt>**0**</tt> through <tt>**9**</tt>, <tt>**a**</tt> through <tt>**f**</tt>, or <tt>**A**</tt> through <tt>**F**</tt>  

#### Floating Point Literals
Floating point literals are made up of a sequence of decimal digits, followed by one or both of a decimal fraction or a decimal exponent. A decimal fraction starts with a decimal point (<tt>**.**</tt>) and is followed by a sequence of decimal digits. An exponent consists of an upper or lowercase <tt>**e**</tt> followed by a sequence of decimal digits indicating the power of 10 that the preceding value should be multiplied by. For example, <tt>6.02e23</tt> represents 6.02 x 10<sup>23</sup>. Negative exponents are also allowed.

Prepending a <tt>**-**</tt> to a floating point literal makes it negative.

Willow allows the use of underscores (<tt>**_**</tt>) in floating point literals to improve readability, but they are ignored by the compiler and don't affect the value. Likewise, leading zeros (<tt>**0**</tt>) are also ignored.

> ##### Grammar of a Floating Point Literal
>
> *floating-point-literal* → *decimal-literal* (*decimal-fraction* *decimal-exponent* | *decimal-fraction* | *decimal-exponent*)
>
> *decimal-fraction* → <tt>**.**</tt> *decimal-literal*  
> *decimal-exponent* → (<tt>**e**</tt> | <tt>**E**</tt>) (<tt>**+**</tt> | <tt>**-**</tt>)? *decimal-literal*

#### String Literals
String literals are sequences of characters surrounded by quotes. The character sequence cannot contain an unescaped double quote (<tt>**"**</tt>), an unescaped backslash (<tt>**\\**</tt>), a carriage return, or a line feed.

There are some special characters that can be included in string literals:

- Null character (<tt>**\0**</tt>)
- Backslash (<tt>**\\\\**</tt>)
- Horizontal tab (<tt>**\t**</tt>)
- Line feed (<tt>**\n**</tt>)
- Carriage return (<tt>**\r**</tt>)
- Double quote (<tt>**\\"**</tt>)
- Single quote (<tt>**\\'**</tt>)

The value of an expression can be inserted into a string literal by placing it between parentheses preceded by a backslash (<tt>**\\**</tt>). Here are some examples that all have the same value:

```willow
"1 1 2 3 5"
"1 1 2 \("3") 5"
"1 1 2 \(3) 5"
"1 1 2 \(1 + 2) 5"
:x = 3
"1 1 2 \(x) 5"
```

> ##### Grammar of a String Literal
>
> *string-literal* → <tt>**"**</tt> (*quoted-text-item* | *interpolated-text-item* | *escaped-character*)* <tt>**"**</tt>  
>
> *quoted-text-item* → Any character except double quote (<tt>**\"**</tt>), backslash (<tt>**\\**</tt>), carriage return, or line feed
> *interpolated-text-item* → <tt>**\\(**</tt> *expression* <tt>**)**</tt>  
> *escaped-character* → <tt>**\0**</tt> | <tt>**\\\\**</tt> | <tt>**\t**</tt> | <tt>**\n**</tt> | <tt>**\r**</tt> | <tt>**\\"**</tt> | <tt>**\\'**</tt>

### Operators
Willow allows the defining and overloading of custom operators.

The whitespace that surrounds an operator is used to determine if it is a prefix, postfix, or infix (binary) operator.
- If the operator has whitespace around both sides or around neither side, it will be treated as an infix operator. For example, the <tt>%%</tt> operator is treated as an infix operator in both <tt>x%%y</tt> and <tt>x %% y</tt>.
- If the operator has whitespace only on the left side, it will be treated as a prefix operator. For example, the <tt>%%</tt> operator is treated as a prefix operator in <tt>x %%y</tt>.
- If the operator has whitespace only on the right side, it will be treated as a postfix operator. For example, the <tt>%%</tt> operator is treated as a postfix operator in <tt>x%% y</tt>.

Note, for this situation, [punctuation](#keywords-and-punctuation) is considered as whitespace.

Remember, the tokens <tt>**=**</tt>, <tt>**<-**</tt>, and <tt>**->**</tt> are reserved and cannot be used as custom operators on their own.

> ##### Grammar of Operators
>
> *operator* → (<tt>**/**</tt> | <tt>**=**</tt> | <tt>**-**</tt> | <tt>**+**</tt> | <tt>**!**</tt> | <tt>**&ast;**</tt> | <tt>**%**</tt> | <tt>**<**</tt> | <tt>**>**</tt> | <tt>**&**</tt> | <tt>**|**</tt> | <tt>**^**</tt> | <tt>**~**</tt>)+



