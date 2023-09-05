const SELECTOR = {
  fileInput: '.form-csv-upload__file-input',
};

class CsvUploadForm {
  constructor(formElement) {
    this.form = formElement;
    this.fileInput = formElement.querySelector(SELECTOR.fileInput);

    this._addEventListeners();
  }

  _addEventListeners() {
    this.fileInput.addEventListener('change', () => {
      this.form.submit();
    });
  }
}

export default CsvUploadForm;
