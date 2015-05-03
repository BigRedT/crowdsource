import os
from multiprocessing import Pool

def run_matlab_command(command_str, working_dir=None, matlab_search_path=None,
                       print_stdout=True, nojvm=False,
                       exit_after=True, show_execution_time=True):
    """
    Launch matlab and run the given command.
    """
    command = ['matlab', '-nodesktop', '-nosplash', '-debug', '-softwareopengl']

    if nojvm:
        command.append('-nojvm')

    exit_command = "exit(0);" if exit_after else ""

    if show_execution_time:
        timer_start = 'tStart_=tic'
        timer_end = 'toc(tStart_)'
    else:
        timer_start = ''
        timer_end = ''

    if matlab_search_path:
        addpath_command = ''.join(
            ["addpath(genpath('{}'));".format(search_path) for search_path in
             matlab_search_path])
    else:
        addpath_command = ''

    if working_dir is not None:
        cd_command = "cd '{}'".format(working_dir)
    else:
        cd_command = ''

    command.extend(["-r",
                    "\"{cd};,"
                    "{addpath};"
                    "{tic}; try, {command},"
                    "catch ex,"
                    "disp(getReport(ex, 'extended'));,"
                    "exit(1);,"
                    "end;,"
                    "{toc};{exit}\"".format(
                        command=command_str,
                        cd=cd_command,
                        addpath=addpath_command,
                        exit=exit_command,
                        tic=timer_start,
                        toc=timer_end)])

    command_str = ' '.join(command)
    
    if(print_stdout):
        print command_str

    return_code = os.system(command_str)

    if return_code != 0:
        raise RuntimeError('ERROR: matlab returned code {}'.format(return_code))


def run_adaptive_crowd(idx):
    cmd = 'run_adaptive_crowd({})'.format(idx)
    print "Running instance: {}".format(str(idx)) 
    run_matlab_command(cmd, \
                       print_stdout=False, nojvm=True, \
                       exit_after=True, show_execution_time=True)


if __name__=='__main__':
    p = Pool(12);
    p.map(run_adaptive_crowd,range(1,12))
