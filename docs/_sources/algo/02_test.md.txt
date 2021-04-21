# Algorithms and data structures by examples

Just like the math series, this tutorial is an introduction to algorithms and data structures. It targets students in the humanities and social sciences but not only because I think that learning by examples can benefit all those who like coding and top-down learning.

## 1. Algorithm, speed and space

Let's first consider two lambda examples designed for illustrative purpose:


```python
%%time
temp_l = []
def print_evens_fast(n):
    i = 0
    while i < n:
        if i % 2 == 0:
            temp_l.append(i)
        i += 2
print_evens_fast(50)
```

    CPU times: user 24 µs, sys: 0 ns, total: 24 µs
    Wall time: 27.9 µs



```python
%%time
temp_l = []
def print_evens_slow(n):
    i = 0
    while i < n:
        if i % 2 == 0:
            temp_l.append(i)
        i += 1
print_evens_slow(50)
```

    CPU times: user 27 µs, sys: 1 µs, total: 28 µs
    Wall time: 30 µs


In the output above, you should mainly focus on the wall time. Roughly speaking, `wall time`, also called `real`, represents actual elapsed time, while `user` and `sys` values represent CPU execution time.

As you see the `print_evens_fast` is slightly fast than the second one. If you have a critical mind, you will object, rightly so, that a single trial is quite subject to randomness. A practical trick would be using the `timeit%%` magic command in Ipython. In this case I'll use `r1 n100` meaning 1 run of 100 loops.


```python
%%timeit -r1 -n100
temp_l = []
def print_evens_fast(n):
    i = 0
    while i < n:
        if i % 2 == 0:
            temp_l.append(i)
        i += 2
print_evens_fast(50)
```

    4.07 µs ± 0 ns per loop (mean ± std. dev. of 1 run, 100 loops each)



```python
%%timeit -r1 -n100
temp_l = []
def print_evens_slow(n):
    i = 0
    while i < n:
        if i % 2 == 0:
            temp_l.append(i)
        i += 1
print_evens_slow(50)
```

    6.65 µs ± 0 ns per loop (mean ± std. dev. of 1 run, 100 loops each)


The same conclusion still stands.

One major drawback of the present example is it's significant artificial aspect. You might wonder: are such `tricks` really useful/necessary in real-life scenarios?

Let's take a look at another example, this time much more practical. Websites often use ID to manage customs. At any time, some IDs are used, and some of them are available for use. When some client tries to acquire a new ID, we want to always allocate it the smallest available one. So how can you find the smallest free ID, which is 10, from the following list?

`[18, 4, 8, 9, 16, 1, 14, 7, 19, 3, 0, 5, 2, 11, 6]`

The most intuitive approach would be a brute-force search. However, this algorithm doesn't scale well. For instance, let's try a list of 50000 ids.


```python
%%time
def brute_force(lst):
    i = 0
    while True:
        if i not in lst:
            print(f"The user can use the free id {i}")
            break
        i = i + 1

import random
# reproductibility
random.seed(0)

nb_ids = 50000
lst = list(range(nb_ids))
lst_shuffled = random.sample(lst, len(lst))
print(f"the first 6 ids of the shuffled list is {lst_shuffled[:6]}")
nb_removed = random.randrange(nb_ids)
lst_shuffled.pop(nb_removed)
brute_force(lst_shuffled)
```

    the first 6 ids of the shuffled list is [25247, 49673, 27562, 2653, 16968, 33506]
    The user can use the free id 34838
    CPU times: user 9.42 s, sys: 10.2 ms, total: 9.43 s
    Wall time: 9.44 s


9.4 s, that's a lot of time. If a user has to wait for 9.4 s before being attributed an ID. Chances are he will be long gone before the process is terminated.

Now if we use another algorithm based on the fact that:

> for a series of n numbers $x_1, x_2, ..., x_n$, some of the $x_i$ must be outside the range [0, n) if there are free numbers, otherwise the list is exactly a permutation of $0, 1, ..., n-1$ and n should be returned as the minimum free number.

Let's translate the above theorem into python：


```python
%%time
def min_free(lst):
    n = len(lst)
    a = [0]*(n+1)
    for x in lst:
        if x < n:
            a[x] = 1
    print(f'The id {a.index(0)} can be used.')

min_free(lst_shuffled)
```

    The id 34838 can be used.
    CPU times: user 4.44 ms, sys: 203 µs, total: 4.64 ms
    Wall time: 4.51 ms


As you can see the min_free version takes only 4.5 ms to find the right id. We don't run multiple loops here because of the huge gap.

There remains a minor issue. Isn't it tedious to run the program each time or even multiple times to have an idea of the speed ? Besides, the performance can differ quite significantly according to one's computer configuration.

Luckily people figured out a easier and more objective way of measuring time called Big O notation (actually it measures the time complexity of an algorithm). For this particular case the time complexity of the brute force one is $O(n^2)$ and the other one $O(n)$. However the faster uses more memory (consider the list a set aside as a bookkeeper), we say that the space complexity is $O(n)$.


```python

```
