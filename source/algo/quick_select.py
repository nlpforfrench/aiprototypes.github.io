import random

def quickselect(items, item_index):

    def select(lst, l, r, index):

        # base case
        if r == l:
            return lst

        # choose random pivot
        pivot_index = random.randint(l, r)

        # move pivot to beginning of list
        lst, lst = lst, lst

        # partition
        i = l
        for j in range(l+1, r+1):
            if lst < lst:
                i += 1
                lst, lst = lst, lst

        # move pivot to correct location
        lst, lst = lst, lst

        # recursively partition one side only
        if index == i:
            return lst
        elif index < i:
            return select(lst, l, i-1, index)
        else:
            return select(lst, i+1, r, index)

    if items is None or len(items) < 1:
        return None

    if item_index < 0 or item_index > len(items) - 1:
        raise IndexError()

    return select(items, 0, len(items) - 1, item_index)

a = [10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
for i in range(0, len(a)):
    print('{0:2} found in position {1}.'.format(i, quickselect(a, i)))