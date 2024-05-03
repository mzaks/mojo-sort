from benchmark import run
from my_utils import corpus1, corpus2, corpus3, corpus4, corpus5, corpus6, corpus7, lte_s
from insertion_sort import insertion_sort
# from string_compare import lt, lt2, lt3
from multi_key_quicksort import multi_key_quicksort
from quick_sort import quick_sort
from csv import CsvBuilder

fn in_sort[get_corpus: fn () -> List[String], lte:fn (String, String) -> Bool]():
    var corpus = get_corpus()
    insertion_sort[String, lte](corpus)

fn mk_sort[get_corpus: fn () -> List[String]]():
    var corpus = get_corpus()
    multi_key_quicksort(corpus)

fn qk_sort[get_corpus: fn () -> List[String], lte:fn (String, String) -> Bool]():
    var corpus = get_corpus()
    quick_sort[String, lte](corpus)


fn report_mean[f: fn()-> None](description: StringLiteral):
    var report1_mk = run[f]()
    print(description, report1_mk.mean("ns"))

fn main():
    report_mean[in_sort[corpus1, lte_s]]("report1_i1")
    # report_mean[in_sort[corpus1, lte_s]]("report1_i2")
    # report_mean[in_sort[corpus1, lte_s]]("report1_i3")
    report_mean[qk_sort[corpus1, lte_s]]("report1_q1")
    # report_mean[qk_sort[corpus1, lte_s]]("report1_q2")
    # report_mean[qk_sort[corpus1, lte_s]]("report1_q3")
    report_mean[mk_sort[corpus1]]("report1_mk")

    report_mean[in_sort[corpus2, lte_s]]("report2_i1")
    # report_mean[in_sort[corpus2, lte_s]]("report2_i2")
    # report_mean[in_sort[corpus2, lte_s]]("report2_i3")
    report_mean[qk_sort[corpus2, lte_s]]("report2_q1")
    # report_mean[qk_sort[corpus2, lte_s]]("report2_q2")
    # report_mean[qk_sort[corpus2, lte_s]]("report2_q3")
    report_mean[mk_sort[corpus2]]("report2_mk")

    report_mean[in_sort[corpus3, lte_s]]("report3_i1")
    # report_mean[in_sort[corpus3, lte_s]]("report3_i2")
    # report_mean[in_sort[corpus3, lte_s]]("report3_i3")
    report_mean[qk_sort[corpus3, lte_s]]("report3_q1")
    # report_mean[qk_sort[corpus3, lte_s]]("report3_q2")
    # report_mean[qk_sort[corpus3, lte_s]]("report3_q3")
    report_mean[mk_sort[corpus3]]("report3_mk")

    report_mean[in_sort[corpus4, lte_s]]("report4_i1")
    # report_mean[in_sort[corpus4, lte_s]]("report4_i2")
    # report_mean[in_sort[corpus4, lte_s]]("report4_i3")
    report_mean[qk_sort[corpus4, lte_s]]("report4_q1")
    # report_mean[qk_sort[corpus4, lte_s]]("report4_q2")
    # report_mean[qk_sort[corpus4, lte_s]]("report4_q3")
    report_mean[mk_sort[corpus4]]("report4_mk")
    
    report_mean[in_sort[corpus5, lte_s]]("report5_i1")
    # report_mean[in_sort[corpus5, lt2]]("report5_i2")
    # report_mean[in_sort[corpus5, lt3]]("report5_i3")
    report_mean[qk_sort[corpus5, lte_s]]("report5_q1")
    # report_mean[qk_sort[corpus5, lt2]]("report5_q2")
    # report_mean[qk_sort[corpus5, lt3]]("report5_q3")
    report_mean[mk_sort[corpus5]]("report5_mk")

    report_mean[in_sort[corpus6, lte_s]]("report6_i1")
    # report_mean[in_sort[corpus6, lt2]]("report6_i2")
    # report_mean[in_sort[corpus6, lt3]]("report6_i3")
    report_mean[qk_sort[corpus6, lte_s]]("report6_q1")
    # report_mean[qk_sort[corpus6, lt2]]("report6_q2")
    # report_mean[qk_sort[corpus6, lt3]]("report6_q3")
    report_mean[mk_sort[corpus6]]("report6_mk")

    report_mean[in_sort[corpus7, lte_s]]("report7_i1")
    # report_mean[in_sort[corpus7, lt2]]("report7_i2")
    # report_mean[in_sort[corpus7, lt3]]("report7_i3")
    report_mean[qk_sort[corpus7, lte_s]]("report7_q1")
    # report_mean[qk_sort[corpus7, lt2]]("report7_q2")
    # report_mean[qk_sort[corpus7, lt3]]("report7_q3")
    report_mean[mk_sort[corpus7]]("report7_mk")
