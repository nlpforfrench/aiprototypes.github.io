![](img/back/2021-04-13-15-43-22.png)
![](img/back/2021-04-13-15-47-25.png)
![](img/back/2021-04-13-15-53-53.png)
![](img/back/2021-04-13-22-48-30.png)
![](img/back/2021-04-13-22-56-14.png)
![](img/back/2021-04-13-23-18-56.png)
![](img/back/2021-04-13-23-32-36.png)
![](img/back/2021-04-14-00-27-13.png!
![](img/back/2021-04-14-00-28-04.png))
# backup

```python
def binary_search(arr, low, high, x):

    # Check base case
    if high >= low:

        mid = (high + low) // 2

        # If element is exactly present at the middle
        if arr[mid] == x:
            return mid

        # If element is smaller than mid, then check left subarray
        elif arr[mid] > x:
            return binary_search(arr, low, mid - 1, x)

        # Else, check right subarray
        else:
            return binary_search(arr, mid + 1, high, x)

    else:
        # Element is not present in the array
        return -1
```
