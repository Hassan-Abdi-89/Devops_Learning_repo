---
title: echo "Enter first number" ...
---

```
echo "Enter first number"
read num1
echo "Enter secoond number"
read num2
```

sum=$((num1 + num2))\
sub=$((num1 - num2))\
mul=$((num1 \* num2))\
div=$((num1 / num2 ))\
\#Adding an if statement because division by zero will break the script

if \[ "$num2" -eq 0 ]; then\
echo "Cannot divide by zero"\
else\
div=$((num1 / num2))\
fi

echo "$num1 + $num2 = $sum"\
echo "$num1 - $num2 = $sub"\
echo "$num1 \* $num2 = $mul"\
echo "$num1 / $num2 = $div"
