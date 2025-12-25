from benchmark import run
from my_utils import corpus1, corpus2, corpus3, corpus4, corpus5, corpus6, corpus7
from insertion_sort import insertion_sort
# from string_compare import lt
from multi_key_quicksort import multi_key_quicksort
# from quick_sort import quick_sort
from radix_sorting import msb_radix_sort
from tim_sort import tim_sort, parallel_tim_sort
# from csv import CsvBuilder

comptime lt = String.__lt__

fn in_sort[get_corpus: fn () -> List[String], lte:fn (String, String) -> Bool]():
    var corpus = get_corpus()
    insertion_sort[String, lte](corpus)

fn mk_sort[get_corpus: fn () -> List[String]]():
    var corpus = get_corpus()
    multi_key_quicksort(corpus)

# fn qk_sort[get_corpus: fn () -> List[String], lte:fn (String, String) -> Bool]():
#     var corpus = get_corpus()
#     quick_sort[String, lte](corpus)

fn msb_radix[get_corpus: fn () -> List[String]]():
    var corpus = get_corpus()
    msb_radix_sort(corpus)

fn std_sort[get_corpus: fn () -> List[String]]():
    var corpus = get_corpus()
    sort(corpus)

fn tm_sort[get_corpus: fn () -> List[String]]():
    var corpus = get_corpus()
    tim_sort(corpus)

fn ptm_sort[get_corpus: fn () -> List[String]]():
    var corpus = get_corpus()
    parallel_tim_sort(corpus)


fn report_mean[f: fn()-> None](description: StringLiteral) raises:
    var report1_mk = run[f](max_runtime_secs=2)
    print(description, report1_mk.mean("ns"))

def main():
    report_mean[in_sort[corpus1, lt]]("report1_ins")
    # report_mean[qk_sort[corpus1, lt]]("report1_qks")
    report_mean[mk_sort[corpus1]]("report1_mks")
    report_mean[msb_radix[corpus1]]("report1_rdx")
    report_mean[std_sort[corpus1]]("report1_std")
    report_mean[tm_sort[corpus1]]("report1_tms")
    report_mean[ptm_sort[corpus1]]("report1_ptm")

    report_mean[in_sort[corpus2, lt]]("report2_ins")
    # report_mean[qk_sort[corpus2, lt]]("report2_qks")
    report_mean[mk_sort[corpus2]]("report2_mks")
    report_mean[msb_radix[corpus2]]("report2_rdx")
    report_mean[std_sort[corpus2]]("report2_std")
    report_mean[tm_sort[corpus2]]("report2_tms")
    report_mean[ptm_sort[corpus2]]("report2_ptm")

    report_mean[in_sort[corpus3, lt]]("report3_ins")
    # report_mean[qk_sort[corpus3, lt]]("report3_qks")
    report_mean[mk_sort[corpus3]]("report3_mks")
    report_mean[msb_radix[corpus3]]("report3_rdx")
    report_mean[std_sort[corpus3]]("report3_std")
    report_mean[tm_sort[corpus3]]("report3_tms")
    report_mean[ptm_sort[corpus3]]("report3_ptm")

    report_mean[in_sort[corpus4, lt]]("report4_ins")
    # report_mean[qk_sort[corpus4, lt]]("report4_qks")
    report_mean[mk_sort[corpus4]]("report4_mks")
    report_mean[msb_radix[corpus4]]("report4_rdx")
    report_mean[std_sort[corpus4]]("report4_std")
    report_mean[tm_sort[corpus4]]("report4_tms")
    report_mean[ptm_sort[corpus4]]("report4_ptm")
    
    report_mean[in_sort[corpus5, lt]]("report5_ins")
    # report_mean[qk_sort[corpus5, lt]]("report5_qks")
    report_mean[mk_sort[corpus5]]("report5_mks")
    report_mean[msb_radix[corpus5]]("report5_rdx")
    report_mean[std_sort[corpus5]]("report5_std")
    report_mean[tm_sort[corpus5]]("report5_tms")
    report_mean[ptm_sort[corpus5]]("report5_ptm")

    report_mean[in_sort[corpus6, lt]]("report6_ins")
    # report_mean[qk_sort[corpus6, lt]]("report6_qks")
    # report_mean[mk_sort[corpus6]]("report6_mks")
    report_mean[msb_radix[corpus6]]("report6_rdx")
    report_mean[std_sort[corpus6]]("report6_std")
    report_mean[tm_sort[corpus6]]("report6_tms")
    report_mean[ptm_sort[corpus6]]("report6_ptm")

    report_mean[in_sort[corpus7, lt]]("report7_ins")
    # report_mean[qk_sort[corpus7, lt]]("report7_qks")
    report_mean[mk_sort[corpus7]]("report7_mks")
    report_mean[msb_radix[corpus7]]("report7_rxd")
    report_mean[std_sort[corpus7]]("report7_std")
    report_mean[tm_sort[corpus7]]("report7_tms")
    report_mean[ptm_sort[corpus7]]("report7_ptm")
    

