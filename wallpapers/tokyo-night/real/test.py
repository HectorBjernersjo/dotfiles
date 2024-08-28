import tkinter as tk
from tkinter import StringVar, Listbox, Scrollbar, END
from fuzzywuzzy import process

# Sample list of items to search
items = [
    "apple",
    "banana",
    "orange",
    "grape",
    "strawberry",
    "watermelon",
    "kiwi",
    "pineapple",
    "mango",
    "blueberry"
]

def update_list(*args):
    search_term = entry_var.get()
    matched_items = process.extract(search_term, items, limit=10)
    listbox.delete(0, END)
    for item in matched_items:
        listbox.insert(END, item[0])

def select_item(event):
    selected = listbox.get(listbox.curselection())
    print(f"Selected: {selected}")

# Set up the main window
root = tk.Tk()
root.title("Fuzzy Finder")
root.geometry("300x400")

# Entry widget for search
entry_var = StringVar()
entry = tk.Entry(root, textvariable=entry_var)
entry.pack(fill=tk.X, padx=10, pady=10)
entry_var.trace("w", update_list)

# Listbox to display results
listbox = Listbox(root, height=20)
listbox.pack(fill=tk.BOTH, padx=10, pady=10, expand=True)
listbox.bind("<Return>", select_item)

# Scrollbar for the listbox
scrollbar = Scrollbar(listbox)
scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
listbox.config(yscrollcommand=scrollbar.set)
scrollbar.config(command=listbox.yview)

# Initialize the listbox with all items
update_list()

# Start the main loop
root.mainloop()
