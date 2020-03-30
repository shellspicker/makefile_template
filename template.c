#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/types.h>
#include <linux/string.h>
#include <linux/list.h>
#include <linux/kfifo.h>
#include <linux/gfp.h>
#include <linux/vmalloc.h>
#include <linux/mm.h>
#include <linux/slab.h>
#include <linux/mempool.h>
#include <linux/swap.h>
#include <linux/kdev_t.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/uaccess.h>
#include <linux/fs.h>
#include <linux/fs_struct.h>
#include <linux/file.h>
#include <linux/mount.h>
#include <linux/dcache.h>
#include <linux/sched.h>
#include <linux/delay.h>
#include <linux/kthread.h>
#include <linux/pid.h>
#include <linux/wait.h>
#include <linux/completion.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/time.h>
#include <linux/timekeeping.h>
#include <linux/timer.h>
#include <linux/semaphore.h>
#include <linux/rwsem.h>
#include <linux/seqlock.h>

static int __init dsm_module_init(void)
{
	return 0;
}

void __exit dsm_module_exit(void)
{
}

module_init(dsm_module_init);
module_exit(dsm_module_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("shellspicker@outlook.com");
MODULE_DESCRIPTION("A module make by dsm.");
MODULE_VERSION("233");