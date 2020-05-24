class DataAPI {
  int year;
  double jan;
  double feb;
  double mar;
  double apr;
  double may;
  double jun;
  double jul;
  double aug;
  double sep;
  double oct;
  double nov;
  double dec;
  double win;
  double spr;
  double sum;
  double aut;
  double ann;

  DataAPI(
    this.year,
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
    this.win,
    this.spr,
    this.sum,
    this.aut,
    this.ann,
  );

  @override
  String toString() {
    return 'DataModel{year: $year, jan: $jan, feb: $feb, mar: $mar, apr: $apr, may: $may, jun: $jun, jul: $jul, aug: $aug, sep: $sep, oct: $oct, nov: $nov, dec: $dec, win: $win, spr: $spr, sum: $sum, aut: $aut, ann: $ann}';
  }
}
