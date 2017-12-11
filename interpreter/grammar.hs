<program> := <statement>+

<statement> :=
    <assignment>
  | <if-statement>
  | <while-statement>
  | <print-statement>
  | <message-statement>
  | <read-statement>
  | <skip_statement>
  | <block>

<assignment> := <identifier> "=" <expression>

<if-statement> := "if" <condition> "then" <statement> "else" <statement>

<while-statement> := "while" <condition> "do" <statement>

<print-statement> := "print" <expression>
  | "println" <expression>

<message-statement> := "message" <string>
  | "messageln" <string>

<read-statement> := "read" <identifier>

<block> := "{" <program> "}"

<expression> := <term>
  | <expression> <add-op> <term>

<term> := <factor>
  | <term> <mult-op> <factor>

<factor> := <identifier>
  | <integer literal>
  | "(" <expression> ")"
