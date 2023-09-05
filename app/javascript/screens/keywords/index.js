import CsvUploadForm from '../../components/csv_upload_form';

const SELECTOR = {
  screen: '.keywords.index',
  uploadForm: '.form-csv-upload',
};

class KeywordScreen {
  constructor(screenElement) {
    this.screenElement = screenElement;
    this._setup();
  }

  _setup() {
    const form = this.screenElement.querySelector(SELECTOR.uploadForm);
    new CsvUploadForm(form);
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const keywordScreen = document.querySelector(SELECTOR.screen);
  if (keywordScreen) {
    new KeywordScreen(keywordScreen);
  }
});
