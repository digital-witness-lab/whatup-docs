# Building Colab Notebooks

The easiest way to prototype analyses and interfaces with Whatup data is via Google Colab notebooks.

<!--ts-->
* [Building Colab Notebooks](./200-building-colab-notebooks.md#building-colab-notebooks)
   * [Why Google Colab](./200-building-colab-notebooks.md#why-google-colab)
   * [Limitations](./200-building-colab-notebooks.md#limitations)
   * [Creating a new Colab notebook](./200-building-colab-notebooks.md#creating-a-new-colab-notebook)
   * [Sharing notebooks in playground mode](./200-building-colab-notebooks.md#sharing-notebooks-in-playground-mode)
   * [Code snippets and guidance](./200-building-colab-notebooks.md#code-snippets-and-guidance)
      * [Fetching data from BigQuery](./200-building-colab-notebooks.md#fetching-data-from-bigquery)
      * [Fetching data from Google Sheets](./200-building-colab-notebooks.md#fetching-data-from-google-sheets)
      * [Accepting user input via widgets](./200-building-colab-notebooks.md#accepting-user-input-via-widgets)
      * [Displaying interactive tables](./200-building-colab-notebooks.md#displaying-interactive-tables)
      * [Displaying charts](./200-building-colab-notebooks.md#displaying-charts)
      * [Allowing users to download data](./200-building-colab-notebooks.md#allowing-users-to-download-data)
      * [Allowing users to copy text to the clipboard](./200-building-colab-notebooks.md#allowing-users-to-copy-text-to-the-clipboard)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->
<!-- Added by: runner, at: Wed Feb 14 22:06:15 UTC 2024 -->

<!--te-->

## Why Google Colab

Google Colab notebooks are *pretty much* the same as [Jupyter notebooks](https://jupyter.org/), but with some collaborative and Google-integrating features. So they're a familiar programming paradigm for most technical people on the WhatsApp Watch team.

The project is already also largely on Google's cloud infrastructure, meaning we can connect to our data with relatively little hassle and not many additional security concerns.

Moreover, Colab notebooks can be shared with — and run by — teammates without requiring them to install anything on their own computers.

## Limitations

The primary limitation with this approach is that, in order to run a notebook that connects to our data, collaborators must have full-read access to the Whatup BigQuery tables.

This limitation isn't inherent or exclusive to Colab, but rather comes from the fact that we have not yet built any finer-grained access tools on top of BigQuery.

Other limitations include those inherent to the notebook interface; e.g., we can't persist user sessions, (generally) can't run notebooks in the background, et cetera.

## Creating a new Colab notebook

Due to the way we've set up the Digital Witness Lab's main Google Drive, it's better to create your Colab notebooks outside of it. To do so, TKTK [where to visit, what to click].

## Sharing notebooks in playground mode

Once you have a version of the notebook you'd like to share with the team, use the *Share* option to invite us, giving us only "Commenter" privileges. This lets us run the notebook in "playground mode" while preventing us from accidentally editing your canonical version of it.

With some exceptions, you'll probably want to share the notebook with code cells pre-collapsed. To do so, collapse the cells before each time you save the notebook.

## Code snippets and guidance

In this section, we're collecting code snippets that will help you start building Colab notebooks quickly.

### Fetching data from BigQuery

Most notebooks will want to fetch data from BigQuery. To do so, include these statements near the top of your notebook:

```python
from google.colab import auth
from google.cloud import bigquery
client = bigquery.Client(project="whatup-395208")
```

... then, prompt the user to authenticate themselves, which will grant the notebook access to their Google account's services:

```python
auth.authenticate_user()
```

(They should use the account on which they've been given BigQuery access.)

To actually run queries, you'll want to pass a BigQuery SQL query to a function like this one:

```python
def query(sql):
    job = client.query(sql)
    results = map(dict, job.result())
    return pd.DataFrame(results)
```

In reality, your function will likely look more complex, perhaps taking advantage of BigQuery's [parameterized queries](https://cloud.google.com/bigquery/docs/parameterized-queries).

### Fetching data from Google Sheets

You can also access Google Sheets spreadsheets from Colab notebooks. The required libraries and authentication steps are, however, slightly different.

Include this code near the top of your notebook:

```python
from google.auth import default as default_creds
import gspread

creds, _ = default_creds()
gspread_client = gspread.authorize(creds)

def get_gsheet(doc, sheet_name):
    rows = doc.worksheet(sheet_name).get_all_records()
    return pd.DataFrame(rows)
```

Then, to designate the document you want to pull from:

```python
doc = gspread_client.open_by_key(
    # Replace with the key in the URL of your sheet
    "1cJ2w-EgFEjOu9a9rTOLd3gTuzW_Lqv-iftA7mlckilk"
)
```

And to fetch the rows from a particular sheet in that document:

```python
data = get_gsheet(doc, "My Sheet Name")
```

### Accepting user input via widgets

You will likely want to accept user input. Although there are several options, [Jupyter Widgets](https://ipywidgets.readthedocs.io/] is probably the easiest option.

Include this code near the top of your notebook:

```python
import ipywidgets as widgets
from IPython.display import display
```

For specific code on building and displaying widgets, see the Jupyter Widgets documentation. The [list of widgets](
https://ipywidgets.readthedocs.io/en/latest/examples/Widget%20List.html) is particularly helpful.

### Displaying interactive tables

Although standard Pandas/Polars-style table outputs may work well in many situations, you might want to use Colab's "Data Table" feature, which adds pagination, filtering, and sorting to table output:

```python
from google.colab import data_table
```

For example:

```python
data_table.DataTable(
    my_dataframe,
    include_index=False,
    num_rows_per_page=10,
)
```

### Displaying charts

You can use standard `matplotlib` and/or `seaborn` charts in Colab notebooks without difficulty.

One complication, however, can arise when you're using them in combination with Jupyter Widgets — specifically when you're generating a chart in one notebook cell but want to display it in the widget output of another. In this case, you'll want to *disable `matplotlib`/`seaborn`'s  default behavior*, which is to auto-display charts in the cell in which they're created:

```python
import matplotlib.pyplot as plt
plt.ioff()
```

Then, to display a generated chart in another widget's output:


```python
from IPython.display import display, Image
import io

def display_plt(plt):
    b = io.BytesIO()
    plt.savefig(b, format='PNG')
    display(Image(b.getvalue()))

with my_widget_output:
    # Replace line below with actual chart
    ax = my_data_frame.plot(x = "a", y = "b")
    display_plt()
```

### Allowing users to download data

Colab provides an easy way to let users download any given dataframe's data:

```python
from google.colab import files
# Replace with a more informative filename
dest = "my-download.csv"
my_dataframe.to_csv(dest, index=False)
files.download(dest)
```

### Allowing users to copy text to the clipboard

In certain situations, you may want to allow users to copy some text (such as a SQL query) to their system's clipboard. Because Colab is running on a server instead of on the user's computer, the typical approaches don't work. This workaround, however, does seem to work:

```python
from IPython.display import HTML
from html import escape
text_to_copy = "Lorem ipsum <aaaa>"
HTML(
  f'<textarea id="cliboard-textarea" style="display:none">{text_to_copy}</textarea>'
  "<button onclick=\"navigator.clipboard.writeText(document.getElementById('clipboard-textarea').value)\"/>Click to Copy</button>"
)
