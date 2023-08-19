## Aim

The following repository aims at sharing the purpose of the macro used
to compare different effectiveness of prior distributions in the process
of multiple imputation. This macro has been written during the SAS
Curiosity Cup, a Hackathon for students. The PDF document that explains
the project is named **SASNuff** and is available for consultation in
this repository.

## Introduction

Decisions about missing values are often discussed as those might have
an important impact on parameter estimates. Deleting observations with
missing values might be wrong if not justified by a clear reasoning
process that depends on the specific domain we are referring to.

Imputing values is also an option, but this has to be justified too, as
the process might be conducted in the wrong way. Imputing missing values
means that we are going to substitute a missing value with a number that
is considered to be a valid representation of that missing observation.

In the health field, multiple imputation is used as a sensitivity
analysis, meaning that it serves as a comparison between the available
case and the complete case analysis.

### Data

The dataset used for our purpose is different from the one used in the
competition, as it has fewer observations and fewer variables, just for
the sake of simplicity. It can easily be extended to a wider dataset.

The considered set of observations is obtained from the *Pistachio type
detection*
[dataset](https://www.kaggle.com/datasets/amirhosseinmirzaie/pistachio-types-detection)
that can be found on Kaggle.

As can be seen from the *pistachio.R* script, only few variables were
selected and then two more categorical features were introduced to show
how multiple imputation with categorical variables works. The script
also contains the code that shows how missing values were introduced
randomly. One other way around might be to simulate data, as illustrated
in the *simulate.R* script. A problem with this approach is that there
might be issues with the identity matrix when the logistic regression is
carried out in SAS, as different variables are correlated between each
other, because of how the simulation process is written.

## Multiple Imputation

How the whole process works is widely explained by the following UCLA
seminar whose slides and material are available
[here](https://stats.oarc.ucla.edu/sas/seminars/multiple-imputation-in-sas/mi_new_1/).
What has to be clear in the user’s mind before applying this process is
that:

-   Multiple imputation aims at restoring the variability that was lost
    because of missing values.

-   The imputation process depends on the characteristics at the base of
    the missingness mechanism, which can be:

    -   **MCAR**, missing completely at random.

    -   **MAR**, missing at random.

    -   **MNAR**, missing not at random.

-   Multiple imputation is divided in three steps:

    -   **Imputation phase**, missing values are filled with values that
        are predicted using other variables in the dataset. As we can
        understand from the adjective *multiple*, more than one dataset
        is obtained from this phase. This task is carried out by **proc
        mi**.

    -   **Analysis**, one for model for each different dataset obtained
        from the **Imputation phase** is carried out.

    -   **Pooling phase**, parameters obtained in the previous step are
        pooled into one for each variable. This task is carried out by
        **proc mianalyze**. When categorical variables are present in
        the dataset, the **classlevel** option is required to indicate
        which variable contains information about levels.

-   Available case and complete case analysis and the respective
    parameters are compared to catch differences.

## Macro

In *macro.sas*, the missingness mechanism is considered to be MAR, so
that standard techniques could be used. The **Fully Conditional
Specification (FCS)** is used when there are variables which do not
assume a joint distribution but instead uses a separate conditional
distribution for each imputed variable. This particular case is useful
when we are dealing with categorical variables.

With continuous variables, the imputation statement to be used is the
**reg** statement, while with categorical variables that have more than
two levels the **discrim** statement is the proper one, which also has
two interesting properties:

-   **classeffects** option, which allows also to use categorical
    variables as predictive features in the imputation process.

-   **prior** option, which permits the user to decide which prior
    should be used to start the imputation.

Metrics that evaluate how well the process was conducted are Relative
efficiency and the trace plot.

In our macro, multiple imputation is repeated for each prior pointed out
in the first argument of the macro and for each of these priors the mean
relative efficiency for each set of variables is recorded and stored in
a dataset, and then compared to decide which prior guarantees the best
performance.

Arguments of the macro are:

-   **dist**: prior distributions to be tested.

-   **k**: index that is used to loop through the arguments.

-   **imp**: number of datasets to be imputed for each prior.

-   **burn**: number of burn-in imputations to be discarded before
    storing values that are to be filled in.

## References

-   [UCLA Multiple Imputation With SAS Part
    1](https://stats.oarc.ucla.edu/sas/seminars/multiple-imputation-in-sas/mi_new_1/)

-   [Multiple Imputation of Missing Data using
    SAS](https://support.sas.com/content/dam/SAS/support/en/books/multiple-imputation-of-missing-data-using-sas/65370_excerpt.pdf)
