void sim(const TString sID, Int_t nev=1000)
{
  gSystem->cd(sID.Data());

//gSystem->Load("liblhapdf");
  gSystem->Load("liblhapdf_5_9_1");
  gSystem->Load("libEGPythia6");
//gSystem->Load("libpythia6");
//gSystem->Load("libpythia6_4_21");
  gSystem->Load("libqpythia");
  gSystem->Load("libAliPythia6");
  gSystem->Load("libHIJING");
  gSystem->Load("libTHijing");
  gSystem->Load("libgeant321");

  if (gSystem->Getenv("EVENT")) nev = atoi(gSystem->Getenv("EVENT"));

  AliSimulation simulator;
  simulator.SetRunGeneration(kTRUE);
  simulator.SetRunSimulation(kFALSE);
  simulator.SetMakeSDigits("");
  simulator.SetMakeDigitsFromHits("");
  simulator.SetWriteRawData("");
  simulator.SetRunQA(":") ; 

  TStopwatch timer;
  timer.Start();
  simulator.Run(nev);
  WriteXsection();
  timer.Stop();
  timer.Print();

  return;
}

void WriteXsection()
{
  TPythia6 *pythia = TPythia6::Instance();
  pythia->Pystat(1);

  Int_t    ntrials  = pythia->GetMSTI(5);
  Double_t xsection = pythia->GetPARI(1);

  cout << "Pythia cross section: " << xsection
       << ", number of trials: " << ntrials << endl;

  TFile *file = TFile::Open("pyxsec_hists.root", "NEW"); TList *list = new TList();
  TProfile *h1Xsec = new TProfile("h1Xsec", "", 1, 0., 1.); list->Add(h1Xsec);
  TH1F  *h1Trials  = new TH1F("h1Trials",   "", 1, 0., 1.); h1Trials->Sumw2(); list->Add(h1Trials);

  h1Xsec->Fill(0.5, xsection);
  h1Trials->Fill(0.5, ntrials);
  file->cd(); list->Write("cFilterList", TObject::kSingleKey); file->Close();

  return;
}
