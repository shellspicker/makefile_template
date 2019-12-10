#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
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
#include <linux/kthread.h>
#include <linux/pit.h>
#include <linux/wait.h>
#include <linux/completion.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/time.h>
#include <linux/timer.h>
#include <linux/seamphore.h>
#include <linux/rwsem.h>
#include <linux/seqlock.h>
#include <asm/atomic.h>

static int __init module_init(void)
{
}

void __exit module_exit(void)
{
}

module_init(module_init);
module_exit(module_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("shellspicker@outlook.com");
MODULE_DESCRIPTION("A module make by dsm.");
MODULE_VERSION("233");
