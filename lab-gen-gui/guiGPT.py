import tkinter as tk
from tkinter import ttk, messagebox, filedialog
from datetime import date
import textwrap
import re
import os

# ----------------------------
# Templates: loaded by a DIFFERENT function
# ----------------------------
def load_templates():
    """
    Return a dictionary of available templates.
    Each template provides a default body and any extra default metadata.
    You can replace/extend this without touching the GUI.
    """
    return {
        "Blank": {
            "body": "# Introduction\n\nWrite your content here.\n",
            "meta": {}
        },
        "Blog Post": {
            "body": textwrap.dedent("""\
                # {title}

                > *Summary:* {summary}

                ## Background
                ...

                ## Main Points
                - Point A
                - Point B

                ## Conclusion
                ...
            """),
            "meta": {"category": "blog", "layout": "post"}
        },
        "Project Notes": {
            "body": textwrap.dedent("""\
                # {title}

                ## Goals
                - 

                ## Tasks
                - [ ] First task
                - [ ] Second task

                ## Notes
                - 

            """),
            "meta": {"type": "notes"}
        },
    }

# ----------------------------
# Utility functions
# ----------------------------
def slugify(text):
    text = text.strip().lower()
    text = re.sub(r"[^a-z0-9\- _]+", "", text)
    text = re.sub(r"[\s_]+", "-", text)
    return text or "untitled"

def yaml_dump(metadata):
    """
    Create a simple YAML block from a dict (no external deps).
    Handles strings, lists, and basic values.
    """
    lines = ["---"]
    for key, value in metadata.items():
        if isinstance(value, list):
            lines.append(f"{key}:")
            for item in value:
                lines.append(f"  - {item}")
        else:
            # Quote strings that contain ':' or '#'
            if isinstance(value, str) and (":" in value or "#" in value):
                lines.append(f'{key}: "{value}"')
            else:
                lines.append(f"{key}: {value}")
    lines.append("---\n")
    return "\n".join(lines)

# ----------------------------
# New Project Dialog
# ----------------------------
class NewProjectDialog(tk.Toplevel):
    def __init__(self, parent, on_created_file_callback=None):
        super().__init__(parent)
        self.title("New Markdown Project")
        self.transient(parent)
        self.grab_set()
        self.resizable(True, True)
        self.on_created_file_callback = on_created_file_callback

        self.templates = load_templates()

        # --- Styling
        self.configure(padx=16, pady=16)
        self.columnconfigure(0, weight=1)
        self.rowconfigure(1, weight=1)

        header = ttk.Label(self, text="Create a New Markdown File", style="Title.TLabel")
        header.grid(row=0, column=0, sticky="w", pady=(0, 12))

        # Main content split: left form, right preview
        main = ttk.Frame(self)
        main.grid(row=1, column=0, sticky="nsew")
        main.columnconfigure(0, weight=1)
        main.columnconfigure(1, weight=1)
        main.rowconfigure(0, weight=1)

        form = ttk.Frame(main)
        form.grid(row=0, column=0, sticky="nsew", padx=(0, 12))
        form.columnconfigure(1, weight=1)

        # Template selector
        ttk.Label(form, text="Template").grid(row=0, column=0, sticky="w", pady=4)
        self.template_var = tk.StringVar(value="Blank")
        self.template_combo = ttk.Combobox(
            form, textvariable=self.template_var, state="readonly",
            values=list(self.templates.keys())
        )
        self.template_combo.grid(row=0, column=1, sticky="ew", pady=4)
        self.template_combo.bind("<<ComboboxSelected>>", lambda e: self.update_preview())

        # Metadata fields
        self.title_var = tk.StringVar(value="My New Document")
        self.author_var = tk.StringVar(value="Author Name")
        self.date_var = tk.StringVar(value=str(date.today()))
        self.tags_var = tk.StringVar(value="notes, draft")
        self.summary_var = tk.StringVar(value="A short one-line summary.")

        row = 1
        for label, var in [
            ("Title", self.title_var),
            ("Author", self.author_var),
            ("Date", self.date_var),
            ("Tags (comma-separated)", self.tags_var),
            ("Summary", self.summary_var),
        ]:
            ttk.Label(form, text=label).grid(row=row, column=0, sticky="w", pady=4)
            entry = ttk.Entry(form, textvariable=var)
            entry.grid(row=row, column=1, sticky="ew", pady=4)
            entry.bind("<KeyRelease>", lambda e: self.update_preview())
            row += 1

        # Extra metadata table (simple key/value add)
        sep = ttk.Separator(form)
        sep.grid(row=row, column=0, columnspan=2, sticky="ew", pady=8)
        row += 1

        ttk.Label(form, text="Extra Metadata (optional)").grid(row=row, column=0, columnspan=2, sticky="w")
        row += 1

        kv = ttk.Frame(form)
        kv.grid(row=row, column=0, columnspan=2, sticky="ew", pady=(4, 0))
        kv.columnconfigure(1, weight=1)

        self.extra_key_var = tk.StringVar()
        self.extra_val_var = tk.StringVar()

        ttk.Entry(kv, textvariable=self.extra_key_var, width=16).grid(row=0, column=0, padx=(0, 6))
        ttk.Entry(kv, textvariable=self.extra_val_var).grid(row=0, column=1, sticky="ew", padx=(0, 6))
        add_btn = ttk.Button(kv, text="Add", command=self.add_extra_meta)
        add_btn.grid(row=0, column=2)

        row += 1
        self.extra_tree = ttk.Treeview(form, columns=("key", "value"), show="headings", height=5)
        self.extra_tree.heading("key", text="Key")
        self.extra_tree.heading("value", text="Value")
        self.extra_tree.grid(row=row, column=0, columnspan=2, sticky="nsew", pady=(6, 0))
        row += 1

        del_btn = ttk.Button(form, text="Remove Selected", command=self.remove_selected_extra)
        del_btn.grid(row=row, column=0, columnspan=2, sticky="w", pady=6)
        row += 1

        # Preview
        right = ttk.Frame(main)
        right.grid(row=0, column=1, sticky="nsew")
        right.rowconfigure(1, weight=1)
        right.columnconfigure(0, weight=1)

        ttk.Label(right, text="Preview").grid(row=0, column=0, sticky="w")
        self.preview = tk.Text(right, wrap="word", height=20, relief="flat", borderwidth=0)
        self.preview.grid(row=1, column=0, sticky="nsew", pady=(4, 0))
        self.preview.configure(font=("Consolas", 10))
        self.preview.configure(background=self.cget("background"))  # blend with Toplevel bg
        self.preview.configure(highlightthickness=1, highlightbackground="#cfcfcf")
        self.preview.configure(state="disabled")

        # Buttons
        btns = ttk.Frame(self)
        btns.grid(row=2, column=0, sticky="e", pady=(12, 0))
        ttk.Button(btns, text="Cancel", command=self.destroy).grid(row=0, column=0, padx=(0, 8))
        ttk.Button(btns, text="Create…", style="Accent.TButton", command=self.create_file).grid(row=0, column=1)

        # Initialize preview
        self.update_preview()

        # Enter submits
        self.bind("<Return>", lambda e: self.create_file())

    def get_metadata(self):
        # Base metadata
        meta = {
            "title": self.title_var.get().strip(),
            "author": self.author_var.get().strip(),
            "date": self.date_var.get().strip(),
        }
        # Tags -> list
        tags = [t.strip() for t in self.tags_var.get().split(",") if t.strip()]
        if tags:
            meta["tags"] = tags

        # Template-provided extra defaults
        tpl = self.templates.get(self.template_var.get(), {})
        tpl_meta = tpl.get("meta", {})
        meta.update({k: v for k, v in tpl_meta.items() if k not in meta})

        # User-added extras (override)
        for iid in self.extra_tree.get_children():
            k = self.extra_tree.set(iid, "key").strip()
            v = self.extra_tree.set(iid, "value").strip()
            if k:
                meta[k] = v
        return meta

    def get_body(self, metadata):
        tpl = self.templates.get(self.template_var.get(), {})
        body = tpl.get("body", "")
        # Allow simple {} interpolation with a few fields
        safe = {
            "title": metadata.get("title", ""),
            "summary": self.summary_var.get().strip(),
        }
        try:
            return body.format(**safe)
        except Exception:
            return body  # if placeholders mismatch, just return as-is

    def update_preview(self):
        meta = self.get_metadata()
        body = self.get_body(meta)
        doc = yaml_dump(meta) + body
        self.preview.configure(state="normal")
        self.preview.delete("1.0", "end")
        self.preview.insert("1.0", doc)
        self.preview.configure(state="disabled")

    def add_extra_meta(self):
        k = self.extra_key_var.get().strip()
        v = self.extra_val_var.get().strip()
        if not k:
            messagebox.showwarning("Missing key", "Please provide a metadata key.")
            return
        self.extra_tree.insert("", "end", values=(k, v))
        self.extra_key_var.set("")
        self.extra_val_var.set("")
        self.update_preview()

    def remove_selected_extra(self):
        for sel in self.extra_tree.selection():
            self.extra_tree.delete(sel)
        self.update_preview()

    def create_file(self):
        meta = self.get_metadata()
        body = self.get_body(meta)
        doc = yaml_dump(meta) + body

        initial = slugify(meta.get("title", "untitled")) + ".md"
        path = filedialog.asksaveasfilename(
            parent=self,
            title="Save Markdown File",
            defaultextension=".md",
            initialfile=initial,
            filetypes=[("Markdown", "*.md"), ("All files", "*.*")]
        )
        if not path:
            return

        try:
            os.makedirs(os.path.dirname(path), exist_ok=True)
            with open(path, "w", encoding="utf-8") as f:
                f.write(doc)
            messagebox.showinfo("Created", f"Markdown file created:\n{path}")
            if self.on_created_file_callback:
                self.on_created_file_callback(path)
            self.destroy()
        except Exception as e:
            messagebox.showerror("Error", f"Could not save file:\n{e}")

# ----------------------------
# Main Application
# ----------------------------
class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("Markdown Project Generator")
        self.geometry("960x600")
        self.minsize(800, 500)

        # --- ttk styling to "look nice"
        style = ttk.Style(self)
        # Use a modern theme if available
        if "clam" in style.theme_names():
            style.theme_use("clam")

        # Typography and padding
        style.configure("Title.TLabel", font=("Segoe UI", 16, "bold"))
        style.configure("Subtle.TLabel", foreground="#555")
        style.configure("TNotebook.Tab", padding=(14, 8))
        style.configure("Accent.TButton", padding=(10, 6))
        style.map("Accent.TButton",
                  foreground=[("active", "!disabled", "black")],
                  background=[("!disabled", "#9fd3ff"), ("active", "#74c0ff")])

        # --- Menu bar with accelerators
        menubar = tk.Menu(self)
        filemenu = tk.Menu(menubar, tearoff=0)
        filemenu.add_command(label="New Project…\tCtrl+N", accelerator="Ctrl+N",
                             command=self.open_new_project_dialog)
        filemenu.add_separator()
        filemenu.add_command(label="Exit", command=self.destroy)
        menubar.add_cascade(label="File", menu=filemenu)

        viewmenu = tk.Menu(menubar, tearoff=0)
        viewmenu.add_command(label="Go to Generate\tCtrl+1", accelerator="Ctrl+1",
                             command=lambda: self.select_tab(0))
        viewmenu.add_command(label="Go to Library\tCtrl+2", accelerator="Ctrl+2",
                             command=lambda: self.select_tab(1))
        viewmenu.add_command(label="Go to Settings\tCtrl+3", accelerator="Ctrl+3",
                             command=lambda: self.select_tab(2))
        menubar.add_cascade(label="View", menu=viewmenu)

        self.config(menu=menubar)

        # --- Header
        header = ttk.Frame(self, padding=(16, 12))
        header.pack(side="top", fill="x")
        ttk.Label(header, text="Markdown Project Generator", style="Title.TLabel").pack(anchor="w")
        ttk.Label(header, text="Create consistent, metadata-rich Markdown files quickly.",
                  style="Subtle.TLabel").pack(anchor="w", pady=(2, 0))

        # --- Tabs
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill="both", expand=True, padx=12, pady=12)

        self.generate_tab = self._build_generate_tab()
        self.library_tab = self._build_library_tab()
        self.settings_tab = self._build_settings_tab()

        self.notebook.add(self.generate_tab, text="Generate")
        self.notebook.add(self.library_tab, text="Library")
        self.notebook.add(self.settings_tab, text="Settings")

        # --- Keyboard shortcuts for tabs + actions
        self.bind_all("<Control-n>", lambda e: self.open_new_project_dialog())
        self.bind_all("<Control-Key-1>", lambda e: self.select_tab(0))
        self.bind_all("<Control-Key-2>", lambda e: self.select_tab(1))
        self.bind_all("<Control-Key-3>", lambda e: self.select_tab(2))

    # --- Tab builders
    def _build_generate_tab(self):
        frame = ttk.Frame(self.notebook, padding=16)
        frame.columnconfigure(0, weight=1)
        frame.rowconfigure(1, weight=1)

        ttk.Label(frame, text="Generate New Project", style="Title.TLabel").grid(row=0, column=0, sticky="w")
        card = ttk.Frame(frame, padding=16, relief="groove")
        card.grid(row=1, column=0, sticky="nsew", pady=(12, 0))
        card.columnconfigure(0, weight=1)

        ttk.Label(card,
                  text="Create a new Markdown file using a template and default metadata."
                  ).grid(row=0, column=0, sticky="w")
        ttk.Button(card, text="New Project…", style="Accent.TButton",
                   command=self.open_new_project_dialog).grid(row=1, column=0, sticky="w", pady=(10, 0))

        return frame

    def _build_library_tab(self):
        frame = ttk.Frame(self.notebook, padding=16)
        frame.columnconfigure(0, weight=1)
        frame.rowconfigure(1, weight=1)

        ttk.Label(frame, text="Library", style="Title.TLabel").grid(row=0, column=0, sticky="w")
        ttk.Label(frame, text="(Optional) A place to list or open recent Markdown files.",
                  style="Subtle.TLabel").grid(row=1, column=0, sticky="w", pady=(6, 0))
        self.recent_list = tk.Listbox(frame, height=10, borderwidth=0, highlightthickness=1,
                                      highlightbackground="#cfcfcf")
        self.recent_list.grid(row=2, column=0, sticky="nsew", pady=(8, 0))
        return frame

    def _build_settings_tab(self):
        frame = ttk.Frame(self.notebook, padding=16)
        ttk.Label(frame, text="Settings", style="Title.TLabel").pack(anchor="w")
        ttk.Label(frame, text="Tip: You can edit templates in load_templates().",
                  style="Subtle.TLabel").pack(anchor="w", pady=(6, 0))

        # Light/Dark-esque minimal toggle (just flips bg of text widgets)
        toggle = ttk.Button(frame, text="Toggle Minimal Contrast", command=self._toggle_contrast)
        toggle.pack(anchor="w", pady=(12, 0))
        return frame

    def _toggle_contrast(self):
        # Simple visual tweak for demonstration purposes
        current = self.cget("background")
        new_bg = "#f5f7fb" if current == "SystemButtonFace" else "SystemButtonFace"
        self.configure(background=new_bg)

    # --- Actions
    def open_new_project_dialog(self):
        NewProjectDialog(self, on_created_file_callback=self._add_recent_file)

    def _add_recent_file(self, path):
        # Add to Library > recent list
        if hasattr(self, "recent_list"):
            self.recent_list.insert(0, path)

    def select_tab(self, index):
        if 0 <= index < len(self.notebook.tabs()):
            self.notebook.select(index)

# ----------------------------
# Main entry
# ----------------------------
if __name__ == "__main__":
    app = App()
    app.mainloop()
