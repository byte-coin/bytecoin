#include "aboutdialog.h"
#include "ui_aboutdialog.h"

#include "clientmodel.h"
#include "clientversion.h"

AboutDialog::AboutDialog(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::AboutDialog)
{
    ui->setupUi(this);

    // Set current copyright year
    ui->copyrightLabel->setText(QString("<html><head/><body><p>") + tr("Copyright") + QString(" &copy; 2009-%1 ").arg(COPYRIGHT_YEAR)
                                + tr("The Bitcoin developers") + QString("</p><p>") + tr("Copyright")
                                + QString(" &copy; 2013-%1 ").arg(COPYRIGHT_YEAR) + tr("The Bytecoin developers")
                                + QString("</p></body></html>"));
}

void AboutDialog::setModel(ClientModel *model)
{
    if(model)
    {
        ui->versionLabel->setText(model->formatFullVersion());
    }
}

AboutDialog::~AboutDialog()
{
    delete ui;
}

void AboutDialog::on_buttonBox_accepted()
{
    close();
}
